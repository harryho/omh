# Stack policies — how a technology family plugs into the modernize harness

The harness core is **stack-neutral**: it defines the *slots* a stack must fill and never the
mechanism that fills them. A **stack policy** is one document that fills every slot for one
technology family. The project declares which policy applies in `omh.config.yaml`
(`stack.policy:`), and the roles read that policy to answer the stack-specific questions the
core deliberately leaves open: what the one verify command is, what counts as the
application's own code, what the core logic is measured against, and which smells are
countable.

This is the seam that keeps the harness generic. A mechanism named in `HARNESS.md`, a role
contract, or a template is a defect; it belongs in a policy.

## The nine slots

Every policy must carry these nine sections, in this order. `check.sh` asserts their presence.

| # | Section | The question it answers |
|---|---|---|
| 1 | Build and verify command | What is the one primary gate command, and how fast should it stay? |
| 2 | Test framework and layout | Where do tests live, how are they named, what runs on every tranche? |
| 3 | Coverage scope rules | What counts as the application's own code, and which mechanism enforces that scope? |
| 4 | Independent oracle strategy | What does this stack compare core logic *against* — never against itself? |
| 5 | Static gates and ratchets | Which smells are countable here, and what mechanism asserts the counts? |
| 6 | Measurement and benchmarks | Which tool times hot paths, and how is machine and dataset provenance recorded? |
| 7 | UI and render probes | How does a desktop UI get launched and asserted without OS input or accessibility hooks? |
| 8 | Slow-suite isolation | What is deliberately slow or flaky-prone, where does it live, and what runs it? |
| 9 | Modernize hazards | What bites when you baseline this stack — the traps this family keeps rediscovering? |

## Rules

1. **Fill every slot.** No "n/a" without a stated reason and a compensating check — a slot
   that genuinely cannot be filled is E3 and the baseline report carries the empty slot
   explicitly.
2. **The core names no mechanism.** If a stack-specific thing appears in `HARNESS.md`,
   `ROLES.md` or a template, it belongs in a policy.
3. **Policies are named by technology family**, not by project: `dotnet`, `java`, `kotlin`,
   `rust`.
4. **New stacks are additive.** Add one file under `stacks/`, list its id in the config
   template's `stack.policy:` comment, and extend `check.sh`'s policy list. The core does not
   change — a Swift or Electron desktop policy is the same nine slots with different answers.
5. **A project may ship its own policy** — a company-internal stack, a legacy framework — by
   pointing `stack.policy` at a document that follows this contract. The contract is the
   interface; the shipped policies are just instances of it.
6. **A policy is data, not law.** It changes without a decisions-register entry, because it
   describes a technology, not a decision the project made. Changing *which* policy applies
   is a project decision and does need one.

## How the tranches use a policy

The ladder in `HARNESS.md` names slots; the policy fills them.

| Rung | Slots filled | What the policy answers |
|---|---|---|
| L0 — the verify command | 1, 2 | the gate command, its budget, where tests live |
| L1 — oracle pins | 2, 4 | what the core logic is compared against |
| L2 — data pipeline pins | 2, 4, 9 | how formats round-trip, where fixtures live |
| L3 — geometry pins | 2, 7 | how render maths is asserted without a window |
| L4 — threading pins | 2, 9 | the stack's threading contracts and how to pin them |
| L5 — UI smoke | 7, 8 | how the real UI launches in-process, and where that suite lives |
| L6 — measurement baselines | 6 | which tool times hot paths, how provenance is recorded |
| L7 — static gates | 5 | which counts are ratchets, and what asserts them |

## Shipped policies

| id | family | state | file |
|---|---|---|---|
| `dotnet` | .NET desktop (WinForms/WPF on modern .NET) | written from the real run named in the provenance note | [`dotnet.md`](dotnet.md) |
| `java` | Java desktop (Swing/AWT/SWT/JavaFX, Maven/Gradle) | working skeleton — correct me with a real run | [`java.md`](java.md) |
| `kotlin` | Kotlin desktop (Compose Desktop/JavaFX, Gradle) | working skeleton — correct me with a real run | [`kotlin.md`](kotlin.md) |
| `rust` | Rust desktop (egui/iced, cargo) | working skeleton — correct me with a real run | [`rust.md`](rust.md) |

## Adding one

Copy the shape of an existing policy, fill all nine sections for your stack, add the id to
the config template's `stack.policy:` comment, and extend `check.sh`'s policy list. Nothing
in the core changes — that is the whole point of the contract. A skeleton is an honest
starting state: fill the slots with the mainstream answer, mark it unproven, and correct it
with the first real run.
