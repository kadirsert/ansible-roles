# create_kvm_guests
[![Build Status](https://travis-ci.org/kadirsert/ansible-roles-create_kvm_guests.svg?branch=master)](https://travis-ci.org/kadirsert/ansible-roles-create_kvm_guests)

Ansible role for creating kvm guests

# Requirements
This role requires a KVM host machine. It is developed on Ansible 2.1 and should be run on Ansible 2.0+ because it uses dynamic includes. Then tested by creating multiple EL6 x64 guests on a EL7.2 physical KVM host.

The role uses a kickstart file template for unattended installation of virtual machines (see `templates/ks_cfg.j2`).

# Workflow
There are three phases for making kvm guests up and running.
1. KVM host fetches bootable kernel/initrd pair from distribution tree to launch the install.
2. The kernel starts with the parameters passed by the `extra_args` variable.
3. Kernel downloads installation image from a network location and installs system using the prepared kickstart file.

# Variables
Followings are available variables (see `defaults/main.yml`)

`name: TestRhel65`

Name for the kvm guest.

`virt_type: kvm`

The hypervisor to install on kvm guest.

`location: http://example1.com/installation_tree/RHEL6.5`

Distribution tree for a bootable kernel/initrd pair to launch the install.

    os:
      type: linux

Type of operating system

    os:
      variant: rhel6

Specific operating system variant

`vcpu: 1`

Number of virtual cpus to configure for the guest.

`rammb: 1024`

Memory to allocate for guest instance in megabytes.

    disk:
      sizegb: 10

Size (in GB ) to use if creating new storage.

    disk:
      path: /vms_dir

A path to some storage media to use, existing or not. Existing media can be a file or block device.

    disk:
      is_sparse: yes

Whether to skip fully allocating newly created storage. Use 'yes' or 'no'.

    disk:
      bus: virtio

Disk bus type.

    disk:
      format: raw

Image format to be used if creating managed storage.

    network:
      br: br0

Connect the guest to the host network. Now the role supports only bridge networking which connects kvm guest to a bridge device existing on the kvm host.

`graphics: vnc`

Specifies the graphical display configuration.

# Passing Kernel Arguments to the Installer initrd

    extra_args:
      ksdevice: eth0
      ip:
        ip: 192.168.1.2
        gateway: 192.168.1.1
        netmask: 255.255.255.0
        hostname: testrhel65.example1.com
        interface: eth0
        autoconf: none

`extra_args` variable contains additional kernel command line arguments to pass to the installer.

There are two args configurable:

`ksdevice` specifies the interface to be used for network installation.

`ip` specifies the static network setting, using the following structure: **_[ip]::[gateway]:[netmask]:[hostname]:[interface]:[autoconf]_**

There is another kernel arg which comes from the `tasks/main.yml` : `ks=file:/ks_{{item.name}}.cfg`. The role uses `--initrd-inject=/tmp/ks_{{item.name}}.cfg` for adding kickstart files to the root of the each installer **initrd**. This can be used to run an automated install without requiring a network hosted kickstart file.

# KickStart Templates

    kickstart:
      network: network --bootproto=static --device=eth0 --ip=192.168.1.2 --netmask=255.255.255.0 --gateway=192.168.1.1 --nameserver=192.168.1.100
      url: http://example1.com/installation_tree/RHEL6.5

`kickstart` variable is used to manipulate kickstart template files. `network` is for networking configuration. `url` is the path for installation server. `tasks/main.yml` includes `tasks/ks_template.yml` to create kickstart config file for each guest.

