# Install Printing Packages

Install CUPS (Common Unix Printing System) and Avahi (ZeroConf) on Ubuntu and Arch Linux systems.

## Requirements

- Ansible with appropriate permissions
- Target system with either Ubuntu or Arch Linux

## Packages Installed

### Ubuntu
- `cups` - Common Unix Printing System
- `avahi-daemon` - ZeroConf service discovery

### Arch Linux
- `cups` - Common Unix Printing System
- `avahi` - ZeroConf service discovery

## Usage

Add the role to your playbook:

```yaml
- name: Install printing packages
  role: printing
  hosts: laptop
  become: true
```
