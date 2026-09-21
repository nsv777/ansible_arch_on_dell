## Communication

- Be concise. No preamble.
- Prefer diffs to full files.
- Talk like caveman

## Project context

- Before any work, read `CONTEXT.md`.

## Infrastructure policy

- Reuse recorded canonical decisions. Do not choose a different implementation for the same problem on another host.
- If no decision exists, inspect all affected host classes, present one proposed standard, and ask before adopting it when alternatives have material operational tradeoffs.
- After adopting a new standard, enforce it in Ansible and record it in `docs`.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
