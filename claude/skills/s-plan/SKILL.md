---
name: s-plan
description: Writes or revises the ticket's plan.md, the implementation plan /s-impl executes. Researches the code the change touches, weighs real options, and breaks the work into verifiable steps that each cite R-ids, then iterates with the user until they approve it. Run after /s-reqs, and again when the requirements change.
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Write the plan in `plan.md`, in the project's format (defaults.md otherwise). A wrong line in a plan becomes
many wrong lines of code, and the plan is the one place the user reviews before code exists. Spend the effort
here, and keep the plan short enough to read in one sitting.

## 1. Inputs

`req.md` (from `/s-reqs`), or `ticket.md` alone when the user chooses to skip requirements. If `req.md` is
`draft`, name its open questions and ask whether to proceed on their defaults; proceeding sets
`proceeded_with_open_questions: true`. Record `req.md`'s `updated_at` as `req_updated_at` (`none` without
`req.md`).

If `plan.md` exists this is a revision: read it in full, change only what the requirements or the user changed,
bump `revision`, update `req_updated_at`, and add a Revision History line. Ticked steps stay ticked unless the
revision rewrites them.

## 2. Size it

Estimate `expected_size` from the requirements. If you can describe the whole diff in one sentence, the plan
is small: skip Relevant Concepts and Options, and write the approach, the steps and the testing plan.

## 3. Research: describe before proposing

Establish what exists before deciding anything. For anything beyond a small plan, send 1–3 Explore agents,
scoped by the requirements. Each returns facts with `file:line`: the code paths involved, the conventions its
neighbours follow, and helpers or patterns to reuse. They describe; they do not critique or propose. Their
findings go into Relevant Concepts, trimmed to what the plan depends on.

Work out `touched_projects` from the paths the plan will change and the project's split of its checks (the
parts its hooks or CI build separately).

## 4. Decide

- **Options only when real.** Where two approaches are both reasonable, record the decision, why, and what was
  rejected. Anything that adds a layer, dependency, config or new file names the simpler alternative it beat
  (the project's scope rules).
- **Prefactor first.** If the change is hard to make in the current structure, the first steps make it easy,
  then the next steps make the easy change. A wide rename or migration goes expand, migrate, contract.
- **Notices.** If the plan triggers one of the project's notices, stop and tell the user before going further,
  and name the notice in Risks.

## 5. Steps

Each step is one reviewable change, in the format's checkbox form:

- the files it touches and what changes in them, with an interface or schema written out only when a later
  step depends on it. Never the implementation code;
- the R-ids it serves;
- a verification command with its expected result, from the project's checks, narrowed to the step where the
  runner allows (one package, one test filter).

Tests belong in the step that changes the behaviour they pin, and each must earn its place under the project's
scope rules. A change the project ties to a particular check (for example an end-to-end suite for auth) ends
with that check. Testing Plan lists the automated commands and the manual checks separately.

## 6. Self-check

Before showing the plan, fix every failure:

- every live R-id maps to at least one step, and to a test or a stated manual check;
- every step cites at least one R-id, or it is scope creep: cut it or record it as a deviation with its cost;
- no placeholders: "TBD", "handle errors appropriately", "add tests", "similar to step N", or a name used
  before a step defines it;
- names stay the same from step to step;
- `expected_size` still matches the steps.

## 7. Approval

Show the plan in the conversation as a summary: the approach, the steps, and the choices the user should
check. Ask for approval. Revise on feedback and ask again until the user approves. Commit only after approval.

## 8. Finish

Per workflow.md. Commit `plan.md` as `<TICKET> workflow: plan (s-plan)`. Next: `/s-impl`.
