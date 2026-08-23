# Proxmox VM Setup Guide

This guide is intended for a home lab or portfolio environment.

## Goal

Create an Ubuntu Server VM in Proxmox VE that can be used for:

- Laravel development
- Laravel staging
- DevOps practice
- Docker
- Nginx
- MySQL / MariaDB
- Git-based deployments

## Prerequisites

You need:

- Proxmox VE installed and accessible
- Ubuntu Server ISO
- Enough CPU, RAM, and storage
- Network access from the VM
- A non-production lab environment

## Recommended VM Specification

For a Laravel portfolio server:

- CPU: 2 cores
- RAM: 4 GB
- Disk: 40 GB
- Network: VirtIO
- BIOS: SeaBIOS or OVMF
- Machine: q35
- Storage controller: VirtIO SCSI
- Guest OS: Linux
- ISO: Ubuntu Server LTS

You can increase resources if your host has enough capacity.

## Step 1 - Upload Ubuntu ISO

In Proxmox:

1. Select your node.
2. Open your ISO storage, commonly `local`.
3. Select **ISO Images**.
4. Click **Upload**.
5. Upload the Ubuntu Server LTS ISO.

## Step 2 - Create the VM

Click **Create VM**.

### General

Example:

```text
Node: pve
VM ID: automatic
Name: ubuntu-laravel-01
```

### OS

Select:

```text
Use CD/DVD disc image file (ISO)
```

Then select your uploaded Ubuntu ISO.

### System

Recommended:

```text
Machine: q35
SCSI Controller: VirtIO SCSI single
QEMU Guest Agent: Enabled
```

### Disk

Recommended:

```text
Bus/Device: SCSI
Disk size: 40 GB
Discard: Enabled
SSD emulation: Enabled if using SSD storage
```

### CPU

Recommended:

```text
Cores: 2
Type: host
```

`host` is useful for a personal lab. For migration compatibility between different physical hosts, another CPU type may be preferable.

### Memory

Recommended:

```text
Memory: 4096 MB
```

### Network

Recommended:

```text
Bridge: vmbr0
Model: VirtIO
```

## Step 3 - Start the VM

Start the VM and open the Proxmox console.

Proceed with Ubuntu installation.

## Step 4 - Install QEMU Guest Agent

After Ubuntu installation:

```bash
sudo apt update
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

In Proxmox, make sure **QEMU Guest Agent** is enabled in the VM options.

## Step 5 - Configure Static IP

For a server, a reserved or static IP is recommended.

First identify the interface:

```bash
ip addr
```

Example Netplan file:

```bash
sudo nano /etc/netplan/01-netcfg.yaml
```

Example:

```yaml
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: false
      addresses:
        - 192.168.1.50/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```

Apply:

```bash
sudo netplan try
sudo netplan apply
```

Use IP values appropriate for your own network.

## Step 6 - Create a Snapshot

Before major changes:

1. Shut down or quiesce the VM when practical.
2. Open **Snapshots** in Proxmox.
3. Create a snapshot such as:

```text
clean-ubuntu-install
```

This gives you a safe rollback point.

## Security Notes

For public-facing servers:

- Do not expose Proxmox management directly to the internet.
- Restrict access with firewall rules or VPN.
- Use SSH keys.
- Disable direct root SSH login.
- Keep packages updated.
- Use separate development and production VMs.
