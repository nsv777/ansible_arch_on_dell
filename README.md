# ansible_arch_on_dell
*Arch Linux on Dell XPS 13*

#### Prerequisite collection install
```sh
ansible-galaxy collection install -r requirements.yml
```

Configure pacman and install ansible_aur:
```sh
ansible-playbook playbooks/initial.yml
```
Then do the rest of the config:
```sh
ansible-playbook playbooks/arch_on_dell.yml
```
i915.enable_psr must be turned off since 5.2 kernel
```sh
$ cat /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
#options root=/dev/mapper/os-root rw i915.enable_psr=1 pcie_aspm=force i915.alpha_support=1
options root=/dev/mapper/os-root rw pcie_aspm=force i915.alpha_support=1 i915.enable_psr=0
```
