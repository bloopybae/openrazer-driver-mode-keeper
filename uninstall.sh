#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run with sudo:"
  echo "  sudo ./uninstall.sh"
  exit 1
fi

systemctl disable --now openrazer-driver-mode-keeper.service 2>/dev/null || true

rm -f /etc/systemd/system/openrazer-driver-mode-keeper.service
rm -f /usr/local/bin/openrazer-driver-mode-keeper

systemctl daemon-reload

echo "Removed service and executable."
echo
echo "Config was left in place:"
echo "  /etc/openrazer-driver-mode-keeper.conf"
echo
echo "Remove it manually if you want:"
echo "  sudo rm /etc/openrazer-driver-mode-keeper.conf"
