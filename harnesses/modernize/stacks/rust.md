# Stack policy — `rust`

**Applies to:** Rust desktop applications — egui, iced, or another Rust UI toolkit, on
cargo.

**State: working skeleton.** Every slot is filled with the mainstream answer for a desktop
app, unproven — the first real run corrects this file, the same way the `dotnet` policy was
written from its run.

Selected with `stack.policy: rust` in `omh.config.yaml`. The nine section headings below
are the contract from [`../README.md`](../README.md); `check.sh` asserts they are all
present.

## 1. Build and verify command

One command is the primary gate:

```
cargo test --workspace --lib --bins
```

Keep the gate on library and binary tests, not the full workspace, if doc-tests or slow
integration tests would stretch it — compile time is this stack's budget killer. Budget it
in the baseline report. Coverage is opt-in via a separate invocation (slot 3), never on the
everyday gate.

## 2. Test framework and layout

Built-in `#[test]` harness: unit tests in `#[cfg(test)]` modules next to the code,
integration tests in `tests/`, named for the behaviour they pin. Committed golden fixtures
under `tests/fixtures` with content hashes when large. The gate compiles clean — warnings
are denied (`#![deny(warnings)]` is a project-rules decision, recorded either way).

## 3. Coverage scope rules

**cargo-llvm-cov** (over llvm-tools), scoped by `--exclude` for generated or vendored
crates and by skipping macro-generated test helpers where they distort the numbers. The
scope lives in the invocation recorded in the baseline report — one canonical command,
never improvised. Verify the covered-file list in the report, not just the percentage.

## 4. Independent oracle strategy

Three honest oracles: a proven crate implementing the same computation; **property-based
tests** (`proptest`/`quickcheck`) against invariants where a golden file cannot exist
(e.g. encode/decode round-trips, monotonicity); or hand-computed vectors for small kernels,
committed as golden files with stated tolerances. Core logic is never compared against
itself. No oracle for a capability is E2: recorded unpinned, never invented.

## 5. Static gates and ratchets

Static gates run in CI-adjacent scripts or as ordinary tests asserting report counts:
**clippy** warning counts as ratchets (a count that may fall and never rise, pinned via
`clippy.toml`), **cargo-deny** for advisory/licence enforcement, and a hard zero on
`unsafe` blocks outside a declared, audited allowlist. Deterministic builds: pin the
toolchain in `rust-toolchain.toml`; record the lockfile as committed and `Cargo.lock`
required.

## 6. Measurement and benchmarks

**Criterion** in `ben/`. Every recorded number lands in the baseline report with machine
and dataset provenance. Save a named baseline (`cargo bench -- --save-baseline <id>`) so a
later tranche can regress against it — **criterion baselines are machine-specific: never
compare across machines; the recorded numbers travel, the baseline files stay local**. Keep
benchmark code out of coverage scope.

## 7. UI and render probes

The probe renders the real UI **offscreen**: drive the app's own update path with synthetic
input events and capture the painted pixels through a software renderer (egui/iced both
support software backends; wgpu offscreen capture is possible but fragile). Assert
non-blank pixels where content must be. Keep the UI shell thin — most probes should hit the
app's logic, not the pixels. Budget every probe; a hung UI probe that never times out is a
hung gate.

## 8. Slow-suite isolation

Compile-heavy and flaky-prone suites are **`#[ignore]` tests** with their own explicit
invocation recorded in the baseline report, or a separate workspace member the gate does not
build. Results are recorded in prose so they survive without CI. A probe that turns flaky
moves here with a tracking entry (E7) — the primary gate never absorbs flake.

## 9. Modernize hazards

| Hazard | What bites | Guard |
|---|---|---|
| Compile time in the gate | the gate takes minutes; nobody runs it | gate on lib/bins only; record the budget; keep heavy deps behind features |
| Feature flags changing the API surface | tests pass under default features, break under the shipped set | gate with `--all-features` or the shipped feature set, recorded |
| Criterion baselines across machines | comparing baselines between machines reports phantom regressions | named baselines are local-only; recorded numbers carry machine provenance |
| `unsafe` outside an allowlist | audit scope silently grows | hard zero outside the declared allowlist; the allowlist is a ratchet |
| Macro-generated code in coverage | coverage measures macro expansions, not logic | skip known macro helpers; verify the covered-file list |
| Offscreen renderer differences | pixels differ across drivers/hosts | software renderer for probes; pixel assertions tolerant, structural assertions preferred |
| Lockfile drift | builds differ between machines | `Cargo.lock` committed; toolchain pinned in `rust-toolchain.toml` |

Record each new hazard in the traps ledger the day you meet it, while the scar is fresh —
run two never rediscovers run one.
