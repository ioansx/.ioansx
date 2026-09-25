# Archive mode

For a merged ticket, from the base branch, with an explicit id (`/s-load <TICKET>`).

- The id must match the ticket id pattern, and the ticket directory must exist. Otherwise stop: the saved
  artifacts were not found.
- Read every file in the ticket directory, including `reviews/`.
- Load nothing else: no tracker, chat, branch history, diff or code.
- Brief under the same headings as the live mode, with these changes:
  - **Ticket**: from `ticket.md`.
  - **Where it stands**: which artifacts exist, and the last review verdict.
  - **Sources**: artifact count only.
  - **Drift & news**: `(not checked in archive mode)`.
  - **Open items**: anything the artifacts leave unresolved.
  - No `Next:` line; the ticket is closed.
