#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script with sudo:"
  echo "sudo ./ubuntu/bootstrap.sh"
  exit 1
fi

echo "Updating Ubuntu..."
apt update
apt upgrade -y

echo "Installing common packages..."
apt install -y   curl   unzip   git   ca-certificates   software-properties-common   ufw   qemu-guest-agent   unattended-upgrades

systemctl enable --now qemu-guest-agent || true

echo "Configuring firewall..."
ufw allow OpenSSH

echo
echo "Ubuntu base setup completed."
echo "Firewall has NOT been force-enabled automatically."
echo "Review SSH access first, then run: sudo ufw enable"
