---
name: s-reqs
description: Writes or updates the ticket's req.md, the numbered requirements (R-ids), assumptions and open questions that the plan, implementation and reviews are judged against. Run after /s-start, and again whenever the ticket, an owner decision or an answered question changes the requirements.
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Turn the ticket into requirements precise enough to build and review against, in `req.md`. Every later artifact
cites R-ids, so the file is a contract: ids are stable forever, and the text says what must be true, not how to
build it.

## 1. Inputs

`ticket.md` (from `/s-start`). If `req.md` exists this is a sync run: read it in full first (§5).

## 2. Sources

Read in this order; later sources are newer:

1. `ticket.md`.
2. The live issue and comments, if a tracker is connected. An owner comment that decides something is the
   highest authority: quote it with its date.
3. The code the ticket touches. Requirements change something that exists, so establish what exists (routes,
   tables, services, config, tests) from the code, with `file:line`. Spawn 1–2 Explore agents when the surface
   is not obvious. Never state a current-behaviour fact you have not seen in code; design docs are leads, not
   evidence.
4. What the user says in this session.

## 3. Write

Follow the project's `req.md` format (defaults.md otherwise).

- **One requirement, one or two testable sentences:** an actor, a trigger, an observable outcome, and the
  refusal cases where they matter (which status, which message, what stays stored). "Works correctly" is not a
  requirement.
- **What, not how.** Name the behaviour, route or table; leave the design to `plan.md`. A requirement may pin an
  existing mechanism when replacing it would be scope creep.
- **Only the ticket's scope** (the project's scope rules). Anything adjacent goes under `## Out of Scope`,
  where the reviews can hold the line.
- **Fixes keep what works.** For a bug fix, add R-ids for the behaviour that must stay unchanged ("… still
  returns 404 for a deleted post"). They give the regression test its target.
- **Assumptions** are places the ticket was silent and you chose. Write each so the owner can veto it at a
  glance.
- **Non-functional requirements** carry numbers where numbers exist, and say when a number is provisional.
- **Notices.** If the change triggers one of the project's notices, stop and tell the user now, and add a
  requirement naming the notice.

## 4. Questions, in rounds

Facts are your job: look them up, or send a subagent. Decisions are the user's.

- Each round asks every open decision whose prerequisites are settled, together, with `AskUserQuestion`
  (up to 4 per call; more calls if needed). Each question offers your recommended answer first.
- A decision that depends on an unanswered one waits for the next round.
- Fold each answer into the R-ids it affects, and record it as `Q<n> (answered)`. One the user defers stays
  `Q<n> (open)`.
- Stop when no decision is left open or the user defers the rest.

## 5. Sync runs

- Ids are stable forever. Retire a requirement per the format. New ones continue from the highest id.
- Fold in what changed since `updated_at`: owner decisions, answered questions, code that moved. An owner
  reversal gets the `## Owner decision` section.
- Leave unchanged requirements alone: a sync run is a delta. Trim stale text instead of appending.
- Update `updated_at`, `open_questions` and `status`.

## 6. Finish

Per workflow.md. Commit `req.md` as `<TICKET> workflow: requirements (s-reqs)`. Report the summary, open
questions, and any drift from the tracker or source that failed to load. Next: `status: final` → `/s-plan`;
`draft` → what the user must answer, then `/s-reqs` again (or `/s-plan` if they choose to proceed with the
defaults).
