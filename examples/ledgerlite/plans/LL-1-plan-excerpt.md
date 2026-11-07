# LL-1 — Implementation Plan (excerpt)

> **Approval:** Harry, 26 Oct 2026 — "build it" (fictional dates)

**Spec:** `../SPEC-LL-1-ledger-and-entries.md` · **Est. effort:** 2 d · **Touched areas:** `src/domain/`, `src/ui/`
**Verification this plan leaves green:** `npm test`, `npm run build`

> **Excerpt — Tasks 3–6 omitted from this example file.** The real plan had six tasks; two are
> shown to demonstrate shape: complete content per step, test-first, commit per task.

**Author** — A · `zai-anthropic` · glm-5.3 · 26 Oct 2026

## Global constraints

- FR-1 owns balances: exactly one module (`src/domain/balance.ts`) computes them; the UI reads.
- Dates are UTC-internal (spec D1); rendering happens only at the UI edge.
- Stack rule: TypeScript strict mode; no `any`.

## Test story

| Layer | What it proves | Where |
|---|---|---|
| **Unit** | balance invariant (AC-1), entry validation (AC-2), tree mutations (AC-3), month summary maths + label (AC-4) | `src/domain/*.test.ts` |
| **Functional** | `npm test` full suite; `npm run build` clean | CI per commit |
| **Coverage** | `vitest --coverage`, report-only this milestone; threshold decided at LL-3 | report |
| **Manual** | none — all four ACs are machine | — |

### Task 1: ledger domain — entries, balances, rejection of mutation

**Files:**
- Create: `src/domain/ledger.ts`
- Test: `src/domain/ledger.test.ts`

**Interfaces:**
- Produces: `type Entry = { id: EntryId; date: string /* UTC ISO */; direction: 'in' | 'out'; amount: number; accountId: AccountId; categoryId: CategoryId }`; `function computeBalances(entries: readonly Entry[]): Record<AccountId, number>`; `function assertMutable(entry: Entry): never` (throws).

- [ ] **Step 1: Failing tests**

```typescript
import { computeBalances, Entry, makeEntry } from './ledger';

const e = (over: Partial<Entry>): Entry => makeEntry({ date: '2026-10-01', direction: 'out', amount: 100, accountId: 'checking', categoryId: 'food', ...over });

test('AC-1: debits equal credits per account', () => {
  const b = computeBalances([e({}), e({ amount: 100, direction: 'in' }), e({ amount: 40 })]);
  expect(b.checking).toBe(-40);
});

test('AC-1: stored entries are immutable', () => {
  const stored = e({});
  expect(() => { stored.amount = 5; }).toThrowTypeError();
});
```

- [ ] **Step 2:** Run `npm test -- ledger` — expected: FAIL (module missing).
- [ ] **Step 3: Implement** `ledger.ts` — `makeEntry` returns `Object.freeze`d entries; `computeBalances` folds `in`/`out` per account.
- [ ] **Step 4:** Run `npm test -- ledger` — expected: PASS.
- [ ] **Step 5:** Commit — `feat(ll1): ledger domain, balance invariant, frozen entries`

### Task 2: entry form — submit, validate, feed

**Files:**
- Create: `src/ui/EntryForm.tsx`
- Test: `src/ui/EntryForm.test.tsx`

**Interfaces:**
- Consumes: `Entry`, `makeEntry` from Task 1.
- Produces: `<EntryForm accounts={AccountId[]} categories={Category[]} onSubmit={(e: Entry) => void} />`.

- [ ] **Step 1: Failing tests** — valid submit calls `onSubmit` once with a frozen entry; empty amount shows a field-level error and calls nothing.
- [ ] **Step 2:** Run `npm test -- entries` — expected: FAIL.
- [ ] **Step 3: Implement** the form; invalid input blocks submit and renders inline errors.
- [ ] **Step 4:** Run `npm test -- entries` — expected: PASS.
- [ ] **Step 5:** Commit — `feat(ll1): entry form with inline validation`

## Appendix — Clarifications (B → A)

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|
| 1 | May the form default the date to today in the user's zone? | Yes — default is presentation; storage stays UTC ISO (D1). | 27 Oct | Task 2 |
