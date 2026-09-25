---
name: s-load
description: Loads everything about the current ticket (its artifacts, the live issue, linked chat threads, and the code involved), works out which workflow stage it is at, and names the next command. Read-only. Use when resuming a ticket, picking up someone else's branch, or asking where a ticket stands; `s-load <TICKET>` on the base branch reads a merged ticket's saved artifacts.
argument-hint: "[TICKET, only on the base branch for a merged ticket]"
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Load the ticket's context so work continues without re-discovery. This skill is read-only: it writes no file,
commits nothing and calls no tool that changes the tracker or chat. If the project has its own skill for
loading ticket context, follow it (workflow.md §2); otherwise follow `~/.claude/skills/s-load/standalone.md`.

Extras, except for a merged ticket read from the base branch:

- **Stage.** The stage is the first row that is not done:

  | Stage | Done when | Next |
  |---|---|---|
  | requirements | `req.md` has `status: final`; or `plan.md` has `proceeded_with_open_questions: true`; or there is no `req.md` and `plan.md` has `req_updated_at: none` | `/s-reqs` |
  | plan | `plan.md` exists, and its `req_updated_at` equals `req.md`'s `updated_at`, or is `none` with no `req.md`, or is missing | `/s-plan` |
  | implementation | every `plan.md` step is ticked, or dropped by a Deviation | `/s-impl` |
  | review | the branch is PR-ready (workflow.md §8) | `/s-review`; if it is `NEEDS_WORK`, first `/s-impl <ids>` |
  | PR | a PR exists for the branch (`gh pr view --json url,state`); merged or closed means the ticket is done | `/s-pr` |

- **Briefing.** "Where it stands" names the stage and the artifact state that decided it, and the briefing ends
  with `Next:`: the stage's command, and what to do first if something blocks it.
