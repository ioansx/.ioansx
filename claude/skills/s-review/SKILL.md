---
name: s-review
description: Reviews the current ticket branch against its requirements from up to eight topics (security, performance, design, architecture, simplicity, tests, runtime, requirements), verifies each finding, and writes the ticket's impl-review.md with an APPROVED or NEEDS_WORK verdict, or with topic arguments writes reviews/<topic>.md for just those topics. Use after /s-impl, and again after fixing findings.
argument-hint: "[topic …]  e.g. security tests"
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Review the change on this branch. With no argument this is the **full review**: every topic with surface in the
diff, one artifact (`impl-review.md`), one verdict. With topic arguments (`$ARGUMENTS`) it is a **topic
review**: only those topics, each writing `reviews/<topic>.md` and leaving `impl-review.md` untouched.

Topics: `security`, `performance`, `design`, `architecture`, `simplicity`, `tests`, `runtime`, `requirements`.
Each uses the project's charter for it when the project has one (a topic review skill's charter, or a review
guide), with that charter's finding-id prefix; otherwise the charter and prefix in defaults.md. An unknown
topic argument: list the valid ones and stop.

The review never edits code. Its output is findings; fixing them is the user's call.

## 1. Inputs

- `<TICKET>` and at least `ticket.md`. Read `req.md` and `plan.md` when they exist.
- `git fetch origin <base>`. The subject is the diff from `git merge-base HEAD origin/<base>`, excluding ticket
  artifacts (the project's review scope, with workflow.md §2's override), plus untracked files outside ticket
  directories, read in full. Both empty: stop, there is nothing to review.
- If the artifact this run writes already exists, this is a re-run (§6).
- If the tree has uncommitted changes outside ticket directories, list them and ask once with
  `AskUserQuestion`: commit them first (recommended), or review them uncommitted. Committing stages those paths
  by name, as `<TICKET> <summary of the changes>`. Reviewing uncommitted records `tree_state: dirty`, and `/s-pr`
  will then need one more review after the changes are committed.

## 2. Scope: the change, not the repository

The diff and the requirements are the whole subject. Every finding points at a line this change added or
modified, and names either the requirement it puts at risk or the defect the change introduces.

No findings about: files the diff does not touch; pre-existing code the change sits beside; the ticket's
artifacts; scratch or generated files; style, naming or coverage preferences no requirement asks for.

Two carve-outs, for defects a diff-only review misses:

- **Ported, moved or duplicated code is fully in scope in its new context**, including defects it carried from
  the original. Provenance never lowers severity. For a port, compare its posture with the original it claims
  parity with (access checks, error handling, cleanup, session expectations). An unexplained difference is a
  finding. A defect confirmed in ported code exists in the original too: say so.
- **Read the unchanged code the change newly wires into.** A new caller, redirect target, route on an existing
  chain, or consumer of a cached answer is only correct if the other end behaves as assumed. The finding still
  anchors on a changed line.

**Calibration.** A reviewer asked to find gaps will usually report some. File only what affects correctness or
a stated requirement. A topic whose charter has no surface in this diff says so in one line and files nothing:
a reviewer that always finds something is unfalsifiable, not thorough.

## 3. Fan-out

This skill authorizes the **Workflow** tool; without it, use parallel Agent subagents. One reviewer per topic in
scope; a small diff may share one reviewer across topics. Each gets: the diff spec from §1 and the
untracked-file list, the paths to `req.md` and `plan.md`, §2 of this file, and its charter. Each returns
candidate findings with `file:line`, severity (the project's scale, defaults.md otherwise) and a confidence
note.

- Full review: skip topics with no surface in the diff and record that in the per-perspective summaries.
- `runtime` runs before `tests`; hand `tests` the runtime behaviour table's load-bearing rows. The other topics
  run in parallel.
- A large diff within one topic may fan out further by module.

## 4. Verification

Every candidate at **medium or above** goes to a fresh verifier whose job is to **disprove** it by reading the
actual code, not just the diff. Confirmed findings are `open`. Dismissed ones are recorded `false-positive` with
the reason, so a later run does not resurface them. Low candidates are recorded without a verifier as
`unverified (low)` and never block a verdict.

**Mirror pass (full review only).** A verifier only argues against a filed finding, so it cannot catch a missing
one. For every path that ends in something irreversible (credentials, deletion, revocation, money, a message
that cannot be unsent), also run a fresh agent with the runtime behaviour table whose job is to **produce** a
failing cell: an adverse event with an outcome worse than intent. What it finds goes through the same verifier.

## 5. Artifacts and verdict

- **Topic review:** write `reviews/<topic>.md` in the project's format (defaults.md otherwise), with the topic's
  id prefix. `PASS` iff no open critical or high finding.
- **Full review:** write `impl-review.md` in the project's format (defaults.md otherwise). **APPROVED** iff no
  open critical or high finding, and every open medium is justified under `## Verdict`. Otherwise NEEDS_WORK.
  Per-perspective summaries are 1–3 sentences each, never pasted transcripts.
- Every finding's **In plain terms** line is written for someone who has not seen the code: what breaks and for
  whom, in one sentence, with no identifiers. "Anyone can download another customer's export, because nothing
  checks who is asking", not "missing authz on the export handler".

## 6. Re-runs are deltas

When the artifact exists, check it again instead of reviewing from scratch:

- verify each previously open finding and update its status (`fixed` says why; nothing is deleted). A commit
  since `reviewed_commit` whose `fix` list names the finding as a whole id is its fix (`fix F3:` and
  `fix F3 F5:` fix F3; `fix F31:` does not): put its sha in `Resolution:`;
- review only what changed since `reviewed_commit`: `git diff <reviewed_commit> -- . <artifact pathspec>`
  against the working tree, plus untracked files;
- do not re-read files outside the delta or re-open findings recorded `false-positive`;
- continue finding ids from the highest one in the file; update `reviewed_commit`, `tree_state` and
  `reviewed_at`.

## 7. Finish

Per workflow.md. Commit the artifacts written: `<TICKET> workflow: review <verdict> (s-review)`, or
`<TICKET> workflow: <topic> review <verdict> (s-review)`.

- List open findings by severity.
- On NEEDS_WORK, ask with `AskUserQuestion` whether to accept any open blocking finding instead of fixing it. An
  accepted finding becomes `wont-fix`, with the user's reason in its `Resolution:` line and in `## Verdict`.
  Recompute `findings_open` and the verdict before committing.
- Report each of the project's notices that the diff triggers. A notice is not a finding and never changes the
  verdict.
- Next: NEEDS_WORK → `/s-impl <ids>` for the findings to fix, then `/s-review`. FAIL (topic review) → fix, then
  the same `/s-review <topic>`. APPROVED → `/s-pr`. A topic review that passes → `/s-review` for the full review
  before the PR.
