# CI decisions

- Lint job is action-only: `ansible/ansible-lint@<pinned>` with
  `args` and `requirements_file: "requirements.yml"`.
- Do not `pip install .` before lint. It installs community `ansible`
  into system python and collides with the action's isolated
  `uv tool install` (`Executables already exist`), plus `@main`
  drifts (e.g. removed `lock` extra).
- Pin lint action to a stable tag (currently `v26.9.0`), not `@main`.
- Lint needs collections resolvable: `requirements.yml` must list every
  collection used (`kewlfft.aur`, `community.general`, `ansible.posix`,
  `kubernetes.core`); the action installs them via `requirements_file`.
- `ansible.cfg` sets `vault_password_file = .vault_pass`, which is
  gitignored and absent in CI. CI writes a dummy `ci-dummy` password file
  before lint so `ansible-playbook --syntax-check` runs; vault vars
  warn-and-skip instead of 39 `internal-error` failures. No real secrets
  in GitHub.
