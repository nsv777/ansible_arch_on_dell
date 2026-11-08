# Install Printing Packages

Install CUPS (Common Unix Printing System), Avahi (ZeroConf), and HPLIP (HP Linux Imaging and Printing) on Ubuntu/Debian and Arch Linux systems.

## Requirements

- Ansible with appropriate permissions
- Target system with either Ubuntu/Debian or Arch Linux

## Packages Installed

### Ubuntu/Debian
- `cups` - Common Unix Printing System
- `cups-browsers` - Web browser support for CUPS
- `avahi` - ZeroConf service discovery
- `avahi-daemon` - Avahi daemon

### Arch Linux
- `cups` - Common Unix Printing System
- `avahi` - ZeroConf service discovery
- `avahi-daemon` - Avahi daemon

## Usage

Add the role to your playbook:

```yaml
- name: Install printing packages
  role: printing
  hosts: laptop
  become: true
```
