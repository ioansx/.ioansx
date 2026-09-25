# s-* workflow

A ticket pipeline for any repository:

```
/s-start → /s-reqs → /s-plan → /s-impl → /s-review → /s-pr        (/s-load at any point)
```

`/s-auto` runs every stage up to `/s-pr` unattended.

Each stage writes one artifact into the ticket's directory, commits it, and names the next command. The skills
bring their own mechanics; the project brings its rules. When the two disagree, the project wins, except for
the overrides below.

## 1. Discover the project

Before anything else, work out the following from the project, and state the result in one line of the report.
Read, in this order: `CLAUDE.md` or `AGENTS.md` at the root, then any workflow document or shared skill
conventions they point to (a `WORKFLOW.md`, `.claude/skills/*/conventions.md`, `CONTRIBUTING.md`). Never invent
a fact the project does not state; use the default and say that you did.

| What | Where it usually is | Default |
|---|---|---|
| **Conventions**: artifact formats, rules, severities | the files above | `defaults.md` |
| **Stage skills**: the project's own skill per stage (ticket snapshot, requirements, full review, topic review, briefing) | `.claude/skills/*/SKILL.md` descriptions | none |
| **Base branch** for PRs | the conventions | `gh repo view --json defaultBranchRef` |
| **Ticket id** in branch names | the conventions | `[A-Z][A-Z0-9]*-[0-9]+` |
| **Ticket directory** | the conventions | `tickets/<TICKET>/` |
| **Tracker and chat** | connected tools (an issue tracker, a chat workspace) | none; work from local artifacts |
| **Checks**: build, lint and test entry points per part of the repo, and rules that some changes need a particular check | task runner, git hooks, CI scripts, the conventions | the project's standard test command |
| **Notices**: changes that need someone told before they ship | the conventions | none |
| **Scope rules**: how far a change may reach | the conventions | `defaults.md` → Proportion |

Below, `<base>`, `<TICKET>` and `<tickets>` mean the discovered base branch, ticket id and ticket directory's
parent (`tickets` by default). The artifact pathspec is `':(exclude,glob)<tickets>/*/**'`.

## 2. The project comes first

- Artifacts follow the project's formats exactly. `defaults.md` fills in only what the project leaves undefined.
  Artifacts written by these skills and by the project's own skills must be readable by both.
- Where the project's text names one of its skills, the `s-*` skill for the same stage satisfies it.
- **Stage skills.** `/s-start` and `/s-load` have no procedure of their own when the project has a skill for
  their stage: read that skill's `SKILL.md` and follow it, apply the overrides below, and add only the extras
  the `s-*` skill lists. Without one, follow the `s-*` skill's `standalone.md`. The other `s-*` skills always
  keep their own procedure.

Two overrides of the project's rules:

- **Commits.** A project rule that skills never commit does not apply; these skills commit per Commits below.
- **Review scope.** A workflow document stored beside the ticket directories (e.g. `<tickets>/WORKFLOW.md`) is
  part of the reviewed change, even when the project's review scope excludes the whole ticket root.

## 3. Prerequisites

Each skill names its inputs. When one is missing, stop and name the skill that produces it. Never invent a
missing input. The ticket comes from the branch name (the ticket id pattern); `/s-start` and `/s-load` on the
base branch take it as an argument instead.

## 4. Writing

Everything a skill produces (artifacts, the report, commit messages, PR descriptions, questions to the user)
follows the project's writing rules, or else: plain words, precise and short, for a reader who reads once and
cold; conclusion first; only load-bearing facts, pointing at code (`file:line`) instead of restating it;
bullets or tables for lists; summaries within about ten lines; on a re-run, trim stale text instead of
appending.

## 5. Commits

Running a skill authorizes the commits it names, and nothing else.

- Stage only the paths the skill wrote, by name: `git add -- <paths>`. Never `git add -A` or `git add .`.
  Leave unrelated changes alone and mention them.
- Message: the project's format, or `<TICKET> <imperative summary>`. Artifact commits:
  `<TICKET> workflow: <artifact> (<skill>)`. End with the co-author trailer the session provides; never add a
  session link.
- Never amend, rebase, force-push or switch branch. Only `/s-start` creates a branch and only `/s-pr` pushes.
- If a hook rejects the commit, fix the cause and commit again.

## 6. Finish

Every skill ends the same way:

1. Commit what it wrote (Commits).
2. Report: what changed, every notice that applies, and anything that failed to load or needs the user.
3. `Next:` the command to run and when. If the pipeline cannot move on, say what unblocks it (for example,
   "answer Q2, then re-run `/s-reqs`").

## 7. Services

Never start services or verify by hand (dev servers, containers, requests against a running app, database
edits) unless the user asks, or the project requires a particular check for a kind of change. Builds, lints and
automated tests are fine.

## 8. PR-ready

The branch is PR-ready for `/s-pr` when all of these hold:

- `impl-review.md` has `verdict: APPROVED` (whichever skill wrote it);
- `tree_state: clean`, meaning the review saw only committed code;
- `git status --porcelain` is empty;
- nothing but ticket artifacts changed since the review:
  `git diff --quiet <reviewed_commit> HEAD -- . <artifact pathspec>`.
