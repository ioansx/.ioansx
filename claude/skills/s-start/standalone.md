# Starting a ticket

## 1. Check

- Uppercase the argument. It must match the ticket id pattern; otherwise ask for a ticket id.
- `git status --porcelain` must be empty. If it is not, list the files and ask the user to commit, stash or
  abort. Never stash on your own.

## 2. Fetch

Fetch the issue and its comments from the tracker, if one is connected. If it is not, or the issue is missing,
offer manual mode: the user pastes the title and description, and `ticket.md` gets `source: manual`.

## 3. Branch

- `git fetch origin <base>`.
- Look for an existing local or remote branch for the ticket, ignoring documentation-only branches. One match:
  `git switch` to it (creating a tracking branch if it is remote-only). Several: ask which.
- Otherwise name the branch per the project's rules, or `<kind>/<TICKET>-<slug>` with `<kind>` one of `feat`,
  `fix` or `chore`. Respect a prefix the user named; ask when the kind of work is unclear. The slug: the title,
  lowercase, `[^a-z0-9]+` → `-`, trimmed, at most about 40 characters. Then
  `git switch -c <branch> origin/<base>`.

## 4. Snapshot

- If `ticket.md` exists, summarize how it differs from the fresh issue and ask: refresh or keep. A refresh
  rewrites it with a new `fetched_at`.
- Otherwise write it in the project's `ticket.md` format (defaults.md otherwise).
