# Stack policy — `java`

> **Skeleton.** The mainstream answer per slot, unproven — correct me with a real run, then
> remove this marker.

**Applies to:** Java desktop applications — Swing/AWT/SWT/JavaFX on a supported JDK, built
with Maven or Gradle.

Selected with `stack.policy: java` in `omh.config.yaml`. The nine section headings below are
the contract from [`../README.md`](../README.md); `check.sh` asserts they are all present.

## 1. Build and verify command

The wrapper command is the gate: `./mvnw -q test` (Maven) or `./gradlew test` (Gradle) — the
wrapper pins the toolchain version so the gate does not drift with the machine. Budget it in
the baseline report, and record the budget honestly: if a cold build takes minutes, the
budget notes daemon-warm timing, not cold-start timing.

## 2. Test framework and layout

JUnit 5, tests in `src/test/java` mirroring `src/main/java`, named for the behaviour they
pin, not the method they call. Test sources are new code — hold them to stricter compiler
settings (warnings-as-errors) than the legacy main tree keeps.

## 3. Coverage scope rules

JaCoCo, with the scope enforced by source-directory excludes: generated sources
(`target/generated-sources/`, annotation-processor output) leave the scope, with the reason
recorded per pattern. Every coverage number travels with its scope — an unscoped number is
E3 territory, not a baseline.

## 4. Independent oracle strategy

The oracle is a proven library, a reference implementation, or committed golden data files —
never the code under test. A one-off script generates the golden files from the independent
implementation; tests compare at a stated tolerance, with the conventions (start-index
offsets, which input series a computation runs on) pinned per function. No oracle for a
capability is E2: recorded as unpinned, with the reason.

## 5. Static gates and ratchets

Checkstyle/SpotBugs/PMD finding counts are the ratchets — they may fall at any time and must
never rise — asserted by an ordinary test inside the gate, so a rise fails the build.
Architecture invariants are ArchUnit rules in the same gate: layering, the core not
importing the UI toolkit, no framework classes above the seam.

## 6. Measurement and benchmarks

JMH, in a **separate Maven module** — the annotation processing JMH needs does not run
inside a module that is not set up for it. Every recorded number lands in the baseline
report's prose with machine and dataset provenance, not only in tool output.

## 7. UI and render probes

Swing probes run the real UI in-process on the event dispatch thread
(`SwingUtilities.invokeAndWait`), render with bundled fixtures, and assert on captured
bitmaps — non-blank pixels where content must be; never OS-level input. On a machine
without a display, run headful under `xvfb`. JavaFX probes go through TestFX or a captured
node snapshot.

## 8. Slow-suite isolation

Integration tests run under Maven failsafe (`*IT` naming) or a Gradle task not wired into
`check` — the gate cannot run them by accident. The JMH module and the UI probe suite live
as separate modules or profiles with their own recorded invocations.

## 9. Modernize hazards

- **Headless default.** A JVM without a display launches headless and the UI probe fails
  obscurely — set headful mode (and `xvfb`) deliberately.
- **JPMS strong encapsulation.** Reflective probes break with `IllegalAccessError` unless
  the packages are opened — record every `--add-opens` the probes need.
- **Surefire/failsafe split.** Unit and integration tests bind to different plugins by
  naming convention; a misnamed integration test silently joins or leaves the gate.
- **Generated members in the coverage scope.** Lombok-generated code distorts the numbers
  unless excluded by pattern, with the reason recorded.
- **Gradle daemon staleness.** A stale daemon serves stale state to a measurement — run
  recorded numbers with a fresh daemon and note it in the provenance.
