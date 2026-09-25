# Defaults

Used only where the project defines nothing of its own (workflow.md §2).

## Severities

**critical**: exploitable, or loses data. **high**: correctness bug or requirement gap. **medium**: quality or
performance concern. **low**: nit.

## Proportion

The requirements are the scope. Change only what they ask for; a nearby improvement, however real, is noise
the reviewer must separate from the change. Note it (a deviation in `plan.md`, or a finding) and leave the
code alone. A test earns its place when it would fail if the behaviour it names broke; a gate, layer,
dependency or config earns its place only by naming the simpler alternative it beat.

## Frontmatter

Values that skills check (verdicts, counts, status) stay single-line `key: value` scalars.

## `ticket.md`

```yaml
---
ticket: <TICKET>
title: <tracker title>
url: <tracker link>
status: <tracker state at fetch time>
fetched_at: <ISO-8601 UTC>
source: tracker | manual
---
```

Body: `## Description` (verbatim), `## Comments` (human comments that matter, attributed, oldest first),
`## Links & Attachments`.

## `req.md`

R-, A- and Q-ids are stable forever: never renumbered, never reused. A requirement that no longer applies keeps
its id, and its text becomes `superseded by R<n>` or `dropped: <reason, date>`.

```yaml
---
ticket: <TICKET>
status: draft | final
updated_at: <ISO-8601 UTC>
open_questions: <int; status is final iff 0>
---
```

Body, in order: `## Summary`; `## Owner decision` (only when an owner reversed an earlier decision: date, quote,
the R-ids it rewrote); `## Functional Requirements` (`- **R1** — <one testable statement>`);
`## Non-functional Requirements`; `## Out of Scope`; `## Assumptions` (`- **A1** — <decision made where the
ticket was silent>`); `## Open Questions` (`- **Q1 (open|answered)** — <question, and the answer once given>`).

## `plan.md`

```yaml
---
ticket: <TICKET>
revision: <int, +1 per revision>
req_updated_at: <req.md's updated_at this revision was written against, or none>
proceeded_with_open_questions: true | false
touched_projects: <comma-separated parts of the repo, by the project's own split, or none>
expected_size: xs | s | m | l     # <50, <150, <400, <1000 changed lines of source and tests
---
```

Sections, in order:

- `## Relevant Concepts`: what exists today, with `file:line`, and helpers to reuse.
- `## Options`: only when there is a real choice. Each gives Decision, Rationale, and what was rejected and why.
  Anything that adds a layer, dependency or config names the simpler alternative it beat.
- `## Recommended Approach`.
- `## Implementation Steps`: one checkbox per reviewable change, prefactoring first:

  ```
  - [ ] 1. **<title>.** <what changes>. Files: `<paths>`. Produces: <interface a later step uses, if any>.
    R1, R3. Verify: `<command>` → <expected result>.
  ```

- `## Testing Plan`: `Automated:` (commands) and `Manual:` (checks a person runs), kept apart. `/s-impl` adds each
  command's result after it (`→ <result>`).
- `## Risks`.
- `## Deviations`: `- Step <n> · <what changed> · <why> · <cost if wrong>` (`F<n>` in place of `Step <n>` for a
  review fix), or `(none)`.
- `## Revision History`: `- r<n>, <date>: <what changed>`.

A change you can describe in one sentence (`xs`, usually `s`) omits Relevant Concepts and Options. The plan
names files and interfaces; it carries code only for an interface or schema, never the implementation. A
`plan.md` in another shape is read as it is; `/s-plan` reshapes it on its next revision.

## `reviews/<topic>.md`

```yaml
---
topic: <topic>
verdict: PASS | FAIL              # PASS iff no open critical or high finding
reviewed_commit: <git rev-parse HEAD>
tree_state: clean | dirty (uncommitted changes included in review)
reviewed_at: <ISO-8601 UTC>
findings_total: <int, every finding whatever its status>
findings_open_critical: <int>
findings_open_high: <int>
findings_open_medium: <int>
findings_open_low: <int>
---
```

Body: `## Summary` (1–3 sentences), then one block per finding, with the topic's id prefix:

```
### SEC3 [high] [open] path/to/file:142
**In plain terms:** <one sentence, no jargon: what breaks, and for whom>
<one paragraph: what is wrong, why it matters, what to do>
Verification: <what the verifier checked and concluded, or `unverified (low)`>
```

Status is `open`, `fixed` (why, in the Verification line), `wont-fix` (the owner's reason) or `false-positive`
(the dismissal reason). Findings are never deleted.

## `impl-review.md`

```yaml
---
ticket: <TICKET>
verdict: APPROVED | NEEDS_WORK    # APPROVED iff no open critical or high finding, and every open medium justified
reviewed_commit: <git rev-parse HEAD>
tree_state: clean | dirty (uncommitted changes included in review)
base: origin/<base>
findings_total: <int, every finding whatever its status>
findings_open: <int, open findings of every severity>
reviewed_at: <ISO-8601 UTC>
---
```

Body, in order: `## Findings` (one block per finding as above, ids `F<n>`, plus a `Resolution:` line: commit
sha, or the fix or rationale); `## R-id fulfillment` (R-id → where implemented → the test or manual check);
`## Per-perspective summaries` (1–3 sentences per topic, including topics with no surface); `## Verdict` (one
paragraph, with the justification for each open medium and the reason for each `wont-fix`).

## Review charters

Each topic reviews only what the change introduces. Id prefixes: SEC, PRF, DSN, ARC, SMP, TST, RTM, REQ.

- **security**: access control on new or changed entry points (can a caller reach another user's or tenant's
  data?); injection wherever input reaches a query, command, path or template; server-side requests to
  caller-supplied URLs; secrets in code, logs or responses; crashes reachable from a request.
- **performance**: work per request that grows with data (queries in loops, unbounded reads, missing
  pagination); hot-path allocations and blocking calls; payload and bundle size.
- **design**: consistency with the neighbours: naming, error shapes, API and UI conventions, user-facing text
  and its translations.
- **architecture**: the project's layering and module boundaries; where new code lives; migrations and
  generated code; configuration combinations an operator could set, not only the ones set today.
- **simplicity**: dead code, abstraction with one user, reinvented helpers, duplicated literals, a diff
  bigger than the problem.
- **tests**: do tests assert behaviour, would they fail if it broke, and were the plan's testing steps done;
  missing edge cases the requirements name.
- **runtime**: model the state and the operations, then drive each path with adverse events (a dependency
  fails or times out, calls interleave, retries, a crash midway) and check the outcome against the
  requirements. Record it as a behaviour table: state · operation · event · outcome · where · verdict.
- **requirements**: every live R-id: where it is implemented, does the behaviour match, what is missing or
  gold-plated beyond Out of Scope; are plan deviations justified.
