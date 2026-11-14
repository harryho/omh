# Stack policies — how a technology family plugs into the upgrade harness

The harness core is **stack-neutral**: it defines the *slots* a stack must fill and never the
mechanism that fills them. A **stack policy** is one document that fills every slot for one
technology family. The project declares which policy applies in `omh.config.yaml`
(`stack.policy:`), and the roles read that policy to answer the stack-specific questions the
core deliberately leaves open.

This is the seam that keeps the harness generic. A mechanism named in `HARNESS.md` or a template
is a defect; it belongs in a policy.

## The eight slots

Every policy must carry these eight sections, in this order. `check.sh` asserts their presence.

| # | Section | The question it answers |
|---|---|---|
| 1 | Source and build units | What does this stack count as a source unit, and as a built unit? |
| 2 | Carrying mechanisms | How does a runtime input get into the shipped output? |
| 3 | Built-unit list | Which set of built units must match between the baseline and the upgrade? |
| 4 | Shipped output form | What does the build produce that actually gets shipped? |
| 5 | Side-car inputs | Which inputs travel *beside* the program rather than inside it? |
| 6 | Build and ship commands | How do we build and package, reproducibly? |
| 7 | Smoke launch | How do we prove the shipped output runs? |
| 8 | Upgrade hazards | What breaks when this stack is upgraded, and what must be checked for it? |

## Rules

1. **Fill every slot.** No "n/a" without a stated reason and a compensating check.
2. **The core names no mechanism.** If a stack-specific thing appears in `HARNESS.md`,
   `ROLES.md` or a template, it belongs in a policy.
3. **Policies are named by technology family**, not by project: `dotnet`, `java`, `web`.
4. **New stacks are additive.** Add one file under `stacks/`, list its id in the config
   template, and the core does not change. The harness is not limited to the families shipped
   here — a React/Angular (web) policy is the same eight slots with different answers.
5. **A project may ship its own policy** — a company-internal stack, a legacy framework — by
   pointing `stack.policy` at a document that follows this contract. The contract is the
   interface; the shipped policies are just instances of it.
6. **A policy is data, not law.** It changes without a decisions-register entry, because it
   describes a technology, not a decision the project made. Changing *which* policy applies is
   a project decision and does need one.

## How the roles use a policy

| Phase | Slot used | By whom |
|---|---|---|
| P0 — state check | 1 | A records the baseline census in the policy's units |
| P1 — spike + direction | 6, 7 | A proves the upgrade builds and launches, in this stack's terms |
| P2 — parity census | 2, 5 | A names each input and how it is carried, using this stack's mechanisms |
| P3 — plan + footprint | 2, 6 | A declares the carrying mechanism per contract row and the audit commands |
| P5a — footprint audit | 3, 4 | The machine audit compares the policy's built-unit list and shipped-output form |
| P5b — smoke + probes | 7 | B launches the shipped output the way the policy prescribes |
| P2, P3, P7 | 8 | A, R and the close note check the policy's hazards explicitly |

## Shipped policies

| id | family | file |
|---|---|---|
| `dotnet` | .NET desktop (Framework → modern .NET, WinForms/WPF) | [`dotnet.md`](dotnet.md) |
| `java` | Java desktop (JDK upgrade, Swing/AWT, Maven/Gradle) | [`java.md`](java.md) |

## Adding one

Copy the shape of an existing policy, fill all eight sections for your stack, add the id to the
config template's `stack.policy:` comment, and extend `check.sh`'s policy list. Nothing in the
core changes — that is the whole point of the contract.
