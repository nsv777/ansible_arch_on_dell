# Printing

The printing role installs CUPS and Avahi through the native package manager using
`ansible.builtin.package`. Package lists are flat role defaults and may be
overridden per distribution. `cups-browsed` is not installed explicitly.

The role enables CUPS and Avahi and adds primary and supplementary members of
the `users` and `wheel` groups to `lp`. Missing groups are ignored.
