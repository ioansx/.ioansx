# Loading ticket context

On the base branch with a ticket id argument, follow `~/.claude/skills/s-load/archive.md` instead and stop
there. Otherwise take `<TICKET>` from the branch.

## 1. Artifacts and branch

Read every file in the ticket directory, including `reviews/`. Then:

```sh
git status --short
git log --oneline "$(git merge-base HEAD origin/<base>)"..HEAD
```

## 2. Tracker

Load the connected tracker and chat tools in one tool search. A disconnected one is a gap to report, not a
failure.

- Fetch the issue and its comments. Differences from `ticket.md` are drift: report them; do not rewrite
  `ticket.md` (that is `/s-start`'s job).
- Fetch every document linked to the issue.
- Collect every URL in the description, attachments and comments.

## 3. Chat

Read, once each, every chat thread linked from the issue, its comments or the ticket artifacts.

## 4. Code

Read, in priority order: the branch diff and untracked files (excluding the ticket directory and `.claude/`);
every path named in `req.md`, `plan.md` and the reviews; paths or stack traces in the issue or threads. For
large files, read the named regions with enough context. If the list is empty (a fresh branch), spawn 1–2
Explore agents scoped by the ticket's subject.

## 5. Briefing

No file writes:

- **Ticket**: id, title, tracker status, one-line goal.
- **Where it stands**: which artifacts exist, the latest review verdict, and what is left.
- **Sources**: counts of artifacts, comments and documents, chat threads and code files; anything that failed
  to load.
- **Drift & news**: `ticket.md` vs the live issue, and anything newer than the artifacts that changes the
  picture.
- **Open items**: open questions, open findings, unticked steps.
