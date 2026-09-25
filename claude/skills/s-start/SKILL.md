---
name: s-start
description: Starts work on a ticket. Creates or resumes the implementation branch off the base branch and snapshots the issue into the ticket directory as ticket.md. First step of the ticket workflow.
argument-hint: ABC-123
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Start work on ticket `$ARGUMENTS`. If the project has its own skill for starting a ticket, follow it
(workflow.md §2); otherwise follow `~/.claude/skills/s-start/standalone.md`.

Extras: finish per workflow.md. Commit `ticket.md` as `<TICKET> workflow: ticket snapshot (s-start)`, and report
the branch and a one-paragraph ticket summary. Next: `/s-reqs`.
