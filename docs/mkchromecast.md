# mkchromecast

Installed from upstream git into `~/Documents/scripts/mkchromecast` on Arch
Linux and Ubuntu; not a distro package.

## Why the patch

`roles/mkchromecast/files/mkchromecast-play-timeout.patch` makes the
post-`play_media` `play()` call non-fatal. Some receivers accept the `LOAD`,
fetch `/stream`, but never answer that redundant command within
pychromecast's 10 second window. The resulting
`RequestTimeout: Execution of play timed out after 10.0 s` used to propagate
and kill the cast process, which in turn gave ffmpeg a broken pipe.

`play_media(autoplay=True)` already starts the stream, so the role only turns
the failed nudge into a warning instead of aborting.

## Updating

The role tracks `master`. Rerun the tag after pulling upstream changes:

```bash
ansible-playbook playbooks/arch_on_dell.yml --tags mkchromecast
```

The git module refuses to work on a tree with local modifications, so the role
reverts the patch, updates the clone, then reapplies the patch. A run with no
upstream changes reverts and reapplies but reports nothing changed.

- Upstream did not touch `mkchromecast/cast.py`: the update is a no-op and the
  patch is reapplied unchanged.
- Upstream touched that file: the reapply fails loudly. Refresh the patch hunks
  against the new upstream code.
- The fix landed upstream: the reverse check succeeds after the update and the
  patch is not reapplied. Delete the patch file and the patch tasks.

## Launcher

`~/.local/bin/mkchromecast` is a symlink to the cloned `bin/mkchromecast`.
That script prepends the repo root to `sys.path`, so no install step and no
venv are needed. `~/.local/bin` itself is mode `0700`.

`~/.local/bin` comes late in `PATH`. Make sure no pacman `mkchromecast` or
`mkchromecast-git` package is installed, otherwise `/usr/sbin/mkchromecast`
wins over the symlink.

## Codec

Use `-c wav` for Chromecast Audio. Live FLAC (`-c flac`) buffers 45+ seconds
and then stalls in `BUFFERING` on that device, while WAV starts at once. Both
are lossless. `-b` is ignored for WAV and FLAC by mkchromecast; it only applies
to mp3, aac, ogg and opus.

## Dependencies

Installed per distribution by `tasks/archlinux.yml` or `tasks/ubuntu.yml`:

- Arch: `git`, `python-flask`, `python-netifaces`, `python-psutil`,
  `python-pychromecast`.
- Ubuntu: `git`, `python3-flask`, `python3-netifaces`, `python3-psutil`,
  `python3-pychromecast`.

Tray and Sonos support are not installed; they are optional imports in the
application.

Ubuntu (through 25.10) ships pychromecast 9.4.0, where `play()` does not wait
for a response and therefore cannot time out. There the patch is inert. It is
still applied so both hosts run identical application code, and it references
only `pychromecast.error.PyChromecastError`, which exists in 9.4.0 and 14.x.
