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
