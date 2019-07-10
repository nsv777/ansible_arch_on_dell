# ansible_arch_on_dell
*Arch Linux on Dell XPS 13*

Configure pacman and install ansible_aur:
```
ansible-playbook playbooks/initial.yml -i hosts.yml
```
Then the do the rest of the config:
```
ansible-playbook playbooks/arch_on_dell.yml -i hosts.yml
```