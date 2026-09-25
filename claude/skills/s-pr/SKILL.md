---
name: s-pr
description: Opens the pull request for the current ticket branch into the base branch, once /s-review has approved exactly what is being pushed. Pushes the branch and writes a short PR description (summary, what to look at, testing, merge danger, notices) that links to the ticket directory for the details. Last step of the ticket workflow.
disable-model-invocation: true
---

Read `~/.claude/skills/s-shared/workflow.md` and follow it.

Open the PR for `<TICKET>`. Invoking this skill authorizes one push of the current branch and one PR, nothing
more.

## 1. Gate

Refuse unless the branch is **PR-ready** (workflow.md §8). When a check fails, say which and what to run:

- not `APPROVED`: fix the blocking findings, then `/s-review`;
- `tree_state: dirty`: commit the reviewed changes, then `/s-review`;
- uncommitted changes: commit or drop them, then `/s-review` if they sit outside ticket directories;
- code changed since the review: `/s-review`, which re-checks only the delta.

Then check for an existing PR: `gh pr view --json state,url`. If it is `MERGED` or `CLOSED`, stop: this branch is
finished, and new work needs a new branch (`/s-start`). If it is `OPEN`, the push below updates it.

## 2. Push

`git push -u origin HEAD`. Any pre-push hook runs the project's checks. If it fails, stop and report the output;
never bypass it with `--no-verify`.

## 3. Description

Short enough that a reviewer reads all of it. The details stay in the ticket directory; link to it, never copy
it. Per workflow.md §4:

- **Summary**: 2–3 sentences, what changes and why, with the issue link.
- **Please look at**: at most five bullets, the things a reviewer could get wrong or miss (behaviour changes,
  removals, risky spots, open questions). Leave out anything the diff shows plainly.
- **Testing**: a few lines from `plan.md`'s Testing Plan: each automated check with its recorded result
  (`<command>` → 84 passed), and the manual checks still to do. Nothing recorded yet: say so.
- **Merge danger**: one line. A one-way door (migration, deletion, external notice, public API) or a two-way door
  (revert the PR), and what breaks, for whom, if it is wrong.
- **Notices**: each of the project's notices that applies, and whom it tells. Omit the section when none
  applies.
- **Details**: a link to the ticket directory on the branch
  (`https://github.com/<org>/<repo>/tree/<branch>/<ticket directory>`), naming what is there: requirements, plan,
  review and the findings left open or accepted.

End with the attribution line the session provides for PR descriptions. Never add a session link.

## 4. Create

Write the body to a file in the session's scratchpad directory, not the repo. Then:

```sh
gh pr create --base <base> --title "<TICKET> <summary from the ticket title>" --body-file <file>
```

If the gate found an open PR, do not create another: report its URL, and ask before replacing its description
with `gh pr edit --body-file`.

## 5. Finish

Per workflow.md; there is nothing to commit. Report the PR URL and any notice that applies. Next: the team
reviews the PR. For each change requested, fix it, then run `/s-review` and `/s-pr` again (this time `/s-pr`
pushes to the open PR).
