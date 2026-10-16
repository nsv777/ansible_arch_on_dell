# strata installation

The `strata` role is applied to the `laptop` inventory group.

Strata is installed per-user from the official GitHub release archive (manual
installation), pinned to a specific version.

- Arch Linux and Ubuntu install the runtime dependencies via their package
  manager (`pacman` / `apt`).
- On Ubuntu, the role disables `kernel.apparmor_restrict_unprivileged_userns`
  (enabled by default since 24.04), which otherwise blocks bubblewrap from
  creating user namespaces and breaks the sandboxed image/PDF/archive previews.
- The release archive is downloaded, checksum-verified, and the binary is
  installed to `~/.local/bin/strata`.
- A desktop entry, application icon, and the `org.freedesktop.FileManager1`
  D-Bus service are installed per-user, and Strata is set as the default
  `inode/directory` handler.
- Strata is registered as the XDG Desktop Portal FileChooser backend via
  `strata --install-portal`, so portal-aware apps use it for Open/Save dialogs.
- `xdg-desktop-portal` versions before 1.20.1 do not discover per-user portal
  metadata. On those systems, the role also installs `strata.portal` under
  `/usr/share/xdg-desktop-portal/portals`; Strata's D-Bus service remains
  per-user. Versions before 1.19 also treat the configured fallback list as an
  unordered set, so the role selects only Strata for `FileChooser` there. After
  an upgrade, the role removes only system metadata it previously marked as
  managed and restores Strata's recorded fallback list without overwriting a
  user-modified preference.

Other distributions and architectures are rejected explicitly by the role.

Before installing Strata's FileManager1 service, the role removes any other
per-user service that provides `org.freedesktop.FileManager1`; two providers
for the same name are chosen arbitrarily.
