# HARNESS — the pipeline a milestone runs through

One milestone per pass. A phase starts only when the previous phase's exit criterion is true.
Roles: A architect, B builder, C spec reviewer, D code reviewer, E independent tester.

```
            ┌────────────────────────── human escalations ──────────────────────────┐
            │                                                                        │
 P0 ──► P1 ──► P1.5 ──► P2 ──► P2.5 ──► P3 ──► P4 ──► P4.5a D review ─┬─► P5 ──► P6 ─┼─► (next milestone)
state   spec    C       plan    C       build   verify  P4.5b E test ─┘   close  next │
check   (A)     review  (A)     review  (B)     gates   (parallel)         note      │
            ◄──── FAIL at any gate returns work one phase, never skipped ────────────┘
```

## Phases — entry and exit

| Phase | Entry | What happens | Exit |
|---|---|---|---|
| **P0 — state check** | a request to work a milestone | tree clean or changes explained; unexplained changes stop everything (escalation E4) | tree state explained |
| **P1 — spec (A)** | tree explained | A writes the spec from the inventory, using the spec template; status Draft until the definition of ready holds: every FR has ≥1 AC; the decisive AC is marked; every machine AC names its gate; no decision left Blocking | spec **Ready to build** |
| **P1.5 — C spec review** | spec Ready | C reviews with the anti-anchoring read order (spec → own checklist → then the plan if one exists); verdict PASS / PASS-WITH-DEVIATIONS / FAIL; FAIL blocks P2; re-review in a new dated file, old reports never edited | verdict recorded, no blocking findings |
| **P2 — plan (A)** | P1.5 exit | A writes the plan (plan template): exact files, complete content, test-first steps, commits, and the mandatory test story (unit / functional / coverage / manual) | plan drafted with test story |
| **P2.5 — C plan review** | plan drafted | C checks the plan against the spec it already reviewed: every AC has a proving task; no step contradicts the spec; the test story is real; the human gate for the plan (if set) is satisfied | plan approved per gates config |
| **P3 — build (B)** | approved plan | B executes task by task: failing test → run it → minimal implementation → green → commit; divergence stops the line for a clarification; estimate drift >1.5× the plan is escalation E3 | every task committed; local checks green |
| **P4 — machine verify** | build complete | every command in config `verification:` runs to green; anything unverifiable is listed explicitly — an unexplained silent skip is a defect | all gates green, or unverified list accepted |
| **P4.5 — D review ∥ E test** | P4 exit | D (code review) and E (independent test) launch in parallel, fresh, independent; both block close; E never reads the plan or B's tests | both verdicts recorded; deviations accepted per gates |
| **P5 — close** | both verdicts in | AC walk with evidence pointers; deviations resolved (minor self-accepted by D and logged; major/blocker → E6); close note written from the template; digest for the human | close note committed; milestone Shipped |
| **P6 — next** | P5 exit | name the next milestone from the inventory; re-check open decisions; re-enter at P0 | next milestone entered |

## Gates

Per-milestone approval checkpoints, each `auto` (agents gate each other; the human sees the
digest) or `human` (the phase pauses for explicit approval before proceeding). Default: all
`auto` (decision D5). The four gates:

| Gate | Pauses… | Default |
|---|---|---|
| `spec` | after P1.5, before the plan is written | auto |
| `plan` | after P2.5, before build starts | auto |
| `deviations` | at P5, before any PASS-WITH-DEVIATIONS list is accepted | auto |
| `close` | at P5, before the milestone is marked Shipped | auto |

Flipping a gate to `human` is the parity-critical switch: a project where five agents sharing one
wrong premise is the worst case should run `spec` and `plan` as human gates.

## Escalations

Hard stops. Each one pauses the milestone for a human decision regardless of gate settings;
removing one from the config requires a dated decisions-register entry.

- **E1 — blocking decision with no safe default.** A blocking question the register cannot answer
  and no default is defensible; grinding on would be guessing with authority.
- **E2 — FAIL persisting after one fix round.** A review or test FAIL that survived one fix +
  re-review round signals a systemic problem, not a local one.
- **E3 — estimate drift >1.5× plan.** The plan's effort estimate is exceeded by half again; the
  plan no longer describes reality — re-scope rather than grind.
- **E4 — unexplained tree state at P0.** Uncommitted or unexpected changes at milestone entry; no
  build happens on a tree nobody can explain.
- **E5 — port claim absent from the inventory.** Any behaviour claimed as carried over from the
  source that the inventory cannot trace: the never-invent tripwire.
- **E6 — major-or-blocker deviation.** D may self-accept only minor deviations; anything major or
  blocking goes to the human with the evidence.

## Evidence and verdicts (applies to every reviewer/tester document)

- Content-neutral launches: the brief carries paths and protocol, never the implementer's
  conclusions — "all tests pass" in a launch prompt is the anchoring this pipeline exists to
  prevent.
- Run it, don't trust it: reviewers and testers re-execute the verification commands themselves
  and record observed output.
- Every verdict cites evidence: a test name, a command output, or a `file:line`. "Looks right" is
  not a verdict.
- Verdict vocabulary everywhere: **PASS · PASS-WITH-DEVIATIONS · FAIL**. A FAIL returns work one
  phase — to B (P3) for code findings, to A (P1/P2) for spec or plan findings. Re-reviews land in
  a new dated file; an old report is never edited.
