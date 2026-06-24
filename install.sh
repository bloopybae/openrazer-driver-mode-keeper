#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run with sudo:"
  echo "  sudo ./install.sh"
  exit 1
fi

install -Dm755 openrazer-driver-mode-keeper /usr/local/bin/openrazer-driver-mode-keeper
install -Dm644 openrazer-driver-mode-keeper.service /etc/systemd/system/openrazer-driver-mode-keeper.service

if [[ ! -f /etc/openrazer-driver-mode-keeper.conf ]]; then
  install -Dm644 openrazer-driver-mode-keeper.conf /etc/openrazer-driver-mode-keeper.conf
  echo "Installed default config to /etc/openrazer-driver-mode-keeper.conf"
else
  echo "Config already exists at /etc/openrazer-driver-mode-keeper.conf; leaving it unchanged"
fi

systemctl daemon-reload
systemctl enable --now openrazer-driver-mode-keeper.service

echo
echo "Installed and started openrazer-driver-mode-keeper.service"
echo
echo "Check status with:"
echo "  systemctl status openrazer-driver-mode-keeper.service"
