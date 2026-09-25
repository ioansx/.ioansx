---
name: s-impl
description: Implements the ticket's plan.md step by step. Makes each step's change, runs its verification, ticks it off and commits it, records every departure from the plan under Deviations, and finishes with fresh check output. Resumes from the first unticked step. Run after /s-plan is approved. With finding ids (/s-impl F3 F5), fixes only those review findings instead.
argument-hint: "[finding ids, e.g. F3 F5 or F1-F7]"
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Carry out `plan.md`. The plan is the contract the user approved: follow its intent, adapt its details to what
the code turns out to be, and record every adaptation.

With finding ids in `$ARGUMENTS`, or with no ids while the plan is fully ticked and `impl-review.md` is
`NEEDS_WORK`, fix review findings instead (§6).

## 1. Inputs

`plan.md` (from `/s-plan`), and `req.md` when it exists; without it, the R-ids to check are the plan's own,
judged against `ticket.md`. Resume from the first unticked step; the ticks and `git log` are the record, not
memory of an earlier session. If the working tree has uncommitted changes you did not make, ask before
touching those files.

`plan.md` uncommitted means `/s-plan` is still waiting for approval, and running `/s-impl` is that approval:
commit `plan.md` as `/s-plan` would (`<TICKET> workflow: plan (s-plan)`), then start.

## 2. Each step

1. Make the change the step describes, in the files it names. Match the surrounding code and the project's
   coding rules.
2. Run the step's verification command. Read the output; compare it with the expected result the plan states.
   Fix and re-run until it matches.
3. Tick the step's box in `plan.md` (`- [x]`).
4. Commit the step's files and `plan.md` together (workflow.md §5): `<TICKET> <what the step did>`.

One step at a time; the next step starts from a committed tree.

## 3. Deviations

The code will not always match the plan. Decide, record, and continue:

- Record each departure under `## Deviations` in `plan.md`:
  `- Step <n> · <what changed> · <why> · <cost if wrong>`. An unrecorded deviation is a decision made in secret.
- Work the plan did not name but the step cannot finish without belongs in that step, recorded. Work it merely
  suggests does not (the project's scope rules): note it as a deviation for a later ticket and leave the code
  alone.
- Landing more than double `expected_size` is a deviation.

Stop and ask the user, instead of deciding, only when the next action:

- is irreversible or reaches outside the worktree (data, infrastructure, anything already pushed);
- touches authentication, authorization or secrets in a way the plan did not describe;
- triggers one of the project's notices that the plan did not declare;
- or the plan is wrong in a way that changes the requirements. Show what the plan expected, what you found, and
  why it matters, then suggest `/s-plan` to revise.

## 4. Done means evidence

When every step is ticked or dropped by a deviation:

- run the project's checks for each part of the repo the change touches, fresh, and read the output;
- run the Testing Plan's automated commands, and any check the project requires for this kind of change;
- check each live R-id against the code, one by one (or, without `req.md`, the ticket's asks);
- list the Testing Plan's manual checks for the user; do not run them (workflow.md §7).

Record each command's result in `plan.md`, after the command in the Testing Plan (`→ 84 passed`,
`→ no matches`), and commit it; the PR links there instead of repeating it. "Should pass" is not a result. Fix
failures as part of the step that caused them, with a commit, or record why not as a deviation.

## 5. Finish

Per workflow.md. The steps are already committed. Report the steps done, the deviations, and the check results.
Next: `/s-review`.

## 6. Fixing review findings

Fix exactly the findings the user picks; the others stay as they are.

- **Which.** The ids in `$ARGUMENTS` (`F3 F5`, ranges like `F1-F7`). Each must be an `open` finding in
  `impl-review.md`; otherwise say so and skip it. With no ids, list the open findings by severity, then ask with
  `AskUserQuestion`: the blocking ones (critical, high, medium) as the first, recommended option, never the lows
  by default, and any other set typed as ids.
- **Each finding.** Make the fix its block describes, run the check that proves it (the one the finding names,
  else the verification command of the plan step that touched the file), and commit it alone:
  `<TICKET> fix F<n>: <summary>`. One finding, one commit; when one change fixes several, one commit names them
  all (`fix F3 F5: <summary>`).
- **Never touch `impl-review.md`**: `/s-review` records the fix from the commit. A fix the plan did not foresee is
  recorded under `## Deviations` in `plan.md` with the finding in place of the step (`- F<n> · …`), committed
  with the fix.
- A finding that turns out to be wrong or not worth fixing: stop and tell the user. Accepting it is
  `/s-review`'s question, not a silent skip.

Finish per workflow.md: report each id with its commit. Next: `/s-review`.
