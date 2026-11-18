# Stack policy — `dotnet`

**Applies to:** .NET desktop applications on modern .NET — WinForms or WPF. Written from the
real desktop run named in [`../HARNESS.md`](../HARNESS.md)'s provenance note: a WinForms app
moved off .NET Framework, then baselined where it stands.

Selected with `stack.policy: dotnet` in `omh.config.yaml`. The nine section headings below
are the contract from [`../README.md`](../README.md); `check.sh` asserts they are all
present.

## 1. Build and verify command

One command is the primary gate, and it is a *test* command, not a build command:

```
dotnet test <solution> -c Release
```

- **Budget it.** The provenance run's gate held 65 tests in ~0.3 s. The budget lives in the
  baseline report and is a ratchet candidate — a gate that takes minutes stops being run,
  which is why the budget row exists.
- **Coverage is opt-in only.** Collection runs when explicitly requested, never on the
  everyday gate. The moment collecting coverage makes the gate slow, the gate stops being
  run — so it never does.
- **Quietly green.** Build warnings flooding the gate output hide the failures that matter;
  new test code compiles clean (slot 2).

## 2. Test framework and layout

- **xunit + the Microsoft test SDK.** One test project per concern, referenced by the
  solution, so the single verify command runs all of them. Tests are named for the behaviour
  they pin, not the method they call.
- **New test code is held to a modern bar.** Test projects carry `Nullable` enable and
  `TreatWarningsAsErrors`; the legacy tree keeps its own settings. The tests are new code and
  do not inherit the old excuses.
- **Fixtures are committed and hashed.** Golden-master data lives as committed JSON files;
  large data fixtures carry a content hash (SHA-256 in the provenance run) so a silent
  fixture change cannot masquerade as a code change.
- **Compare tails, not whole-series snapshots**, at a stated tolerance — so a fixture
  extension does not rewrite every golden file.

## 3. Coverage scope rules

**Scope:** the application's own code only. The exclusions — generated designer output
(`*.Designer.cs`), the settings and resource designers, assembly-attribute files, and each
vendored third-party component — each carry their reason in the settings file itself. The
runtime and the NuGet packages are never instrumented in the first place, so they need no
entry.

**Mechanism:** the collector's settings file is applied **automatically** through the test
project's `RunSettingsFilePath` property. The scope cannot be forgotten, because there is
nothing left to pass on the command line — every coverage run, whoever invokes it, measures
the same set of files.

The pattern rules below bit in the provenance run; each is also a hazards-table row:

- pattern lists are **comma-separated** — a semicolon list parses as one single
  never-matching pattern and excludes nothing, silently;
- a pattern needs a **wildcard segment**: `**/*Name.cs` matches, a literal
  `**/dir/Name.cs` does not;
- **SourceLink stays off** — it rewrites the reported file names into URLs, which breaks
  every path-based exclusion;
- output goes to **one deterministic path**, and old results are cleaned **before**
  collecting — the HTML report tool merges *every* matching file it finds, so one stale file
  poisons the report with last month's numbers;
- XML comments in MSBuild and settings files cannot contain `--`.

## 4. Independent oracle strategy

The oracle is **an independent implementation in a different language**. A generator script
runs it over the same inputs and writes committed golden files; the tests compare the app's
output against those files at a stated tolerance (the provenance run: 1e-6). Core logic is
never compared against itself — a snapshot of your own output proves stability, not
correctness.

- **Pin the conventions per function**, not just the numbers: start-index offsets, and which
  input series a computation runs on. A routine that computes on an average-of-prices series
  where the textbook expects close prices produces silently wrong values, not failures — the
  series choice is part of the pin.
- **A ported wrapper that differs from the textbook gets its own guard test** — the
  wrapper's actual input contract is pinned explicitly, so the divergence is documented
  behaviour rather than a latent surprise.
- No oracle for a capability is E2: the finding is recorded as unpinned, with the reason.
  An oracle is never invented.

## 5. Static gates and ratchets

Static gates are **ordinary tests inside the primary gate** — they fail the build, which is
the only place a gate is real.

- **Count ratchets.** Legacy smells become count-allowlist tests: the count may fall at any
  time and must never rise (`lock (this)` occurrences, console writes in library code, and
  the like). A rise fails the gate; a fall is free.
- **Wildcard assembly versions count ZERO.** A wildcard version breaks deterministic builds
  — and breaks the benchmark harness (slot 6). Zero is a hard count, not a ratchet.
- **Optional privacy gate.** Forbidden names are read from a file *outside* the repository
  (its path arrives via the environment), so the forbidden names themselves never enter the
  repo. The gate skips — it does not fail — when the file is absent.
- **Scan mechanics.** Walk the source tree with a per-file size cap, skip build and vendor
  directories, and strip comments per line before matching — a commented-out example of a
  forbidden pattern is not a hit.

## 6. Measurement and benchmarks

**BenchmarkDotNet** times the hot paths. Every recorded number lands in the baseline report
with machine and dataset provenance — a benchmark row without its machine is a rumour with a
decimal point.

Traps, each **Verified** 17–18 Nov 2026 in the provenance run (that run's traps ledger):

- the benchmark project's **`.csproj` file name must exactly equal its `AssemblyName`** —
  the child-process lookup is case-sensitive even on a case-insensitive file system, and the
  failure mode is a confusing "cannot find the assembly" from the benchmark's children;
- pass **`--cli`** with the SDK path when the SDK is not on the `PATH` the children inherit —
  the child processes do not find the toolchain by themselves;
- always pass **`--filter *`** — a bare run drops into an interactive selection prompt that
  hangs a machine runner;
- a reference to a pre-built interop DLL trips the optimizations validator — suppress that
  validator for the benchmark project, and record why in the traps ledger;
- the artifacts directory is git-ignored; the recorded numbers travel in the baseline
  report, not in the artifacts.

## 7. UI and render probes

The probe launches the **real UI in-process** — real window class, real render pipeline — on
a dedicated STA thread with a message pump, drives it through the application's own APIs,
captures the rendered surface into a bitmap, and asserts **non-blank pixels** where content
must be. A dump switch (an environment variable) writes the captured PNGs so a failure can
be inspected after the fact.

Traps:

- **OS accessibility automation deadlocks against the UI thread** — invoke-style patterns
  cross threads the wrong way and hang the run. Never use them; drive through the app's own
  APIs and assert on pixels.
- **The test runner executes tests on MTA threads.** The UI needs STA — so the probe needs a
  dedicated-thread harness that owns the thread, the pump and the cleanup, not the runner's
  thread pool.
- **Budget the probe.** A hung UI probe that never times out is a hung gate.

## 8. Slow-suite isolation

The UI smoke suite and the benchmarks live as **separate projects deliberately not
referenced by the solution** — the verify command cannot run them even by accident. Each has
its own invocation, recorded in the baseline report, and results are **recorded in prose**
(README tables) so they survive without CI.

A probe that turns flaky moves here with a tracking entry (E7) — the primary gate never
absorbs flake, and never silently.

## 9. Modernize hazards

| Hazard | What bites | Guard |
|---|---|---|
| Semicolon-separated exclusion patterns | the list parses as one never-matching pattern; nothing is excluded, silently | comma-separate; check the excluded-file count in the report |
| Literal path pattern in exclusions | the pattern never matches; the generated file stays in scope | use a wildcard segment: `**/*Name.cs` |
| SourceLink on | reported file names become URLs; path exclusions break | keep it off in the collector settings |
| Stale coverage files | the report tool merges every matching file; old numbers poison the new report | one deterministic output path; clean before collecting |
| `--` inside an XML comment | MSBuild and settings files fail to parse | reword the comment — `--` is illegal in XML comments |
| `.csproj` file name ≠ `AssemblyName` | benchmark children cannot find their executable (case-sensitive lookup) | keep the file name identical, byte for byte |
| SDK off the children's `PATH` | benchmark children report no toolchain found | pass `--cli` with the SDK path explicitly |
| Bare benchmark selection | the run drops into an interactive prompt and hangs | always pass `--filter *` |
| OS accessibility automation | deadlock against the UI thread | drive the UI through its own APIs; pixel probes only |
| Runner's MTA test threads | STA UI contracts violated in confusing ways | dedicated STA thread harness owning the pump |
| App-settings initialization not idempotent | a second initialization in the test host throws | initialize once in a shared helper every test entry uses |
| Quoted arguments through a Windows shell bridge | the shell mangles arguments containing spaces; the command line reaches the tool wrong | call the SDK binary directly or drive it from PowerShell |
| Save/load format mismatch | a pipeline's writer emits what its own reader cannot parse | pin round-trips even when they fail — a failing round-trip is a finding, not a skipped test |

Record each new hazard in the traps ledger the day you meet it, while the scar is fresh —
run two never rediscovers run one.
