# CI decisions

- Lint job is action-only: `ansible/ansible-lint@<pinned>` with
  `args` and `requirements_file: "requirements.yml"`.
- Do not `pip install .` before lint. It installs community `ansible`
  into system python and collides with the action's isolated
  `uv tool install` (`Executables already exist`), plus `@main`
  drifts (e.g. removed `lock` extra).
- Pin lint action to a stable tag (currently `v26.9.0`), not `@main`.
