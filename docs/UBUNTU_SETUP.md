# Ubuntu Server Setup Guide

This guide prepares Ubuntu Server for a Laravel or DevOps portfolio environment.

## Step 1 - Update the Server

```bash
sudo apt update
sudo apt upgrade -y
```

## Step 2 - Set Hostname

Example:

```bash
sudo hostnamectl set-hostname laravel-server
```

Check:

```bash
hostnamectl
```

## Step 3 - Configure Timezone

Example for the Philippines:

```bash
sudo timedatectl set-timezone Asia/Manila
```

Check:

```bash
timedatectl
```

## Step 4 - Create an Admin User

Example:

```bash
sudo adduser deploy
sudo usermod -aG sudo deploy
```

Do not use weak passwords.

## Step 5 - Configure SSH Key Authentication

On your local machine:

```bash
ssh-keygen -t ed25519
```

Copy your public key:

```bash
ssh-copy-id deploy@SERVER_IP
```

Test:

```bash
ssh deploy@SERVER_IP
```

Only after confirming key authentication works should you consider disabling password login.

## Step 6 - Harden SSH

Edit:

```bash
sudo nano /etc/ssh/sshd_config
```

Recommended settings:

```text
PermitRootLogin no
PubkeyAuthentication yes
```

If you are certain SSH key login works, you may also use:

```text
PasswordAuthentication no
```

Validate configuration before restart:

```bash
sudo sshd -t
```

Then:

```bash
sudo systemctl restart ssh
```

## Step 7 - Configure UFW

Install if required:

```bash
sudo apt install -y ufw
```

Allow SSH before enabling the firewall:

```bash
sudo ufw allow OpenSSH
```

For a web server:

```bash
sudo ufw allow 'Nginx Full'
```

Enable:

```bash
sudo ufw enable
sudo ufw status
```

## Step 8 - Install Common Utilities

```bash
sudo apt install -y \
  curl \
  unzip \
  git \
  ca-certificates \
  software-properties-common \
  qemu-guest-agent
```

## Step 9 - Optional Automatic Security Updates

```bash
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

## Step 10 - Reboot

```bash
sudo reboot
```
