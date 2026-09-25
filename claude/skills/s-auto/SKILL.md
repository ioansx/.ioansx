---
name: s-auto
description: Runs the ticket workflow unattended, from wherever the ticket stands up to the PR: /s-start, /s-reqs, /s-plan, /s-impl, then /s-review and /s-impl fixes until the review approves. Stops before /s-pr. After three full reviews that still need work, stops and asks the user to help revise the requirements and plan.
argument-hint: "[ABC-123, when starting from the base branch]"
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Drive the ticket to PR-ready (workflow.md §8) without the user. Each stage is its `s-*` skill: read
`~/.claude/skills/<skill>/SKILL.md` and follow it, with the overrides below. Invoking this skill authorizes every
commit those skills make. Nothing is pushed: `/s-pr` stays the user's.

## 1. Where to start

- On the base branch with a ticket argument: `/s-start <TICKET>`.
- On a ticket branch: find the stage with `/s-load`'s stage table and start there. A PR already open, merged or
  closed: stop and say so.

## 2. Stages

Run each stage in order, then the review loop (§3).

| Stage | Override when running it here |
|---|---|
| `/s-reqs` | Do not ask. For each open decision, take the answer you would have recommended, record it as an Assumption (`A<n>`), and set `status: final`. |
| `/s-plan` | Do not wait for approval: running `/s-auto` approves the plan. Commit it and move on. |
| `/s-impl` | As written. |

Notices (the project's) do not stop the run: record them where the stage skill says, and list them in the final
report. `/s-pr` is where they matter.

## 3. Review loop

Repeat:

1. `/s-review` (full review). Do not ask whether to accept findings; never accept one on the user's behalf.
2. `APPROVED`: done, go to §5.
3. `NEEDS_WORK` and the review budget is spent (below): go to §4.
4. Otherwise `/s-impl` with the ids of every open critical, high and medium finding. A finding that turns out
   wrong or not worth fixing: leave it, say why in the report, and let the next review judge it again.

**Review budget: 3 full reviews per plan revision.** Count them from git, so a resumed run counts the same: the
commits that touched `impl-review.md` after the last commit that changed `plan.md`'s `revision:` line
(`git log -1 --format=%H -G '^revision:' -- <plan.md>`). Revising the plan starts a fresh budget.

## 4. When the reviews keep failing

Stop working unattended. Tell the user, in about ten lines:

- the findings still open, and which of them came back after a fix;
- your diagnosis: which requirement is ambiguous or missing, which Assumption was probably wrong, or where the
  plan's approach fights the code;
- what you propose to change in `req.md` and `plan.md`.

Then run `/s-reqs` (a sync run) and `/s-plan` (a revision) with the user, as written, without §2's overrides:
ask the questions, and wait for plan approval. Once the user approves, continue unattended from `/s-impl` with a
fresh review budget.

## 5. Stop before the PR

Also stop, and hand back, whenever a stage skill says to stop and ask the user (for example `/s-impl`'s list of
irreversible or unplanned security-sensitive actions). Say which stage, why, and how to resume: `/s-auto`.

Finish per workflow.md. The report:

- the stages run, and the review count and verdict;
- **Decided for you:** every Assumption this run added, one line each, so the user can veto them;
- deviations from the plan, open low findings, and the Testing Plan's manual checks;
- every notice that applies.

Next: `/s-pr` once the manual checks pass; to change a decision above, `/s-reqs` or `/s-plan`, then `/s-auto`.
