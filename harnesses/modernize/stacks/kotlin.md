# Stack policy — `kotlin`

> **Skeleton.** The mainstream answer per slot, unproven — correct me with a real run, then
> remove this marker.

**Applies to:** Kotlin desktop applications — Compose Desktop or JavaFX on the JVM, built
with Gradle.

Selected with `stack.policy: kotlin` in `omh.config.yaml`. The nine section headings below
are the contract from [`../README.md`](../README.md); `check.sh` asserts they are all
present.

## 1. Build and verify command

The wrapper command is the gate: `./gradlew test` — the wrapper pins the Gradle version, so
the gate does not drift with the machine. Budget it in the baseline report, daemon warm,
and record the budget honestly (warm timing, not cold-start timing).

## 2. Test framework and layout

kotlin.test over JUnit 5, tests in `src/test/kotlin` mirroring main, named for the
behaviour they pin. Test sources are new code — hold them to the stricter warnings profile
(`allWarningsAsErrors`) that the legacy main tree does not carry.

## 3. Coverage scope rules

Kover, with generated code excluded by pattern — Compose-generated members, `buildConfig`
output, DSL-generated code — each exclusion carrying its reason in the build file. Every
number travels with its scope; an unscoped number is E3 territory, not a baseline.

## 4. Independent oracle strategy

The same strategy as the `java` family: a proven library, a reference implementation, or
committed golden data files — never the code under test. Compare at a stated tolerance,
with the conventions (start-index offsets, input series) pinned per function; a one-off
script generates the golden files from the independent implementation. No oracle for a
capability is E2.

## 5. Static gates and ratchets

detekt and ktlint finding counts are the ratchets — they may fall at any time and must
never rise — asserted by an ordinary check inside the gate. Architecture invariants (the
core not importing Compose, layering rules) are asserted as Konsist or ArchUnit rules in
the same gate.

## 6. Measurement and benchmarks

kotlinx-benchmark (the JMH compiler plugin), in a **separate Gradle module**. Machine and
dataset provenance are recorded with every number, in the baseline report's prose.

## 7. UI and render probes

Compose Desktop components render offscreen: drive the composition with bundled fixtures
and assert on the produced image — screenshot comparison, non-blank pixels where content
must be. JavaFX goes through TestFX or a captured node snapshot. Never OS-level input; the
probe drives the app's own state, then reads pixels.

## 8. Slow-suite isolation

The benchmark module and any UI probe suite live as separate Gradle modules not wired into
`check` — the gate cannot run them by accident. Their invocations and results are recorded
in prose so they survive without CI.

## 9. Modernize hazards

- **Compose compiler / Kotlin version lockstep.** The Compose compiler plugin is bound to a
  Kotlin release; upgrading one without the other breaks the build — pin the pair and
  record the pin.
- **Coroutines `runTest` virtual time.** A timing assertion inside `runTest` measures
  virtual time, not real time — measurements run outside it, on a real dispatcher.
- **Gradle Kotlin DSL version skews.** Build-logic Kotlin and project Kotlin drift apart
  between modules — keep the versions declared in one place.
- **Compose in the coverage scope.** Recomposition and generated members distort the
  numbers — exclude by pattern, with reasons, or the baseline lies.
