#!/bin/bash
# Auto Installer: Restart EarnApp tiap 2 jam (hemat resource)
# Lokasi file utama: /usr/local/bin/restart-earnapp.sh

set -e

echo "=== Membuat script restart EarnApp ==="
cat << 'EOF' > /usr/local/bin/restart-earnapp.sh
#!/bin/bash
# Restart EarnApp sekali jalan

echo "Stopping EarnApp..."
earnapp stop
sleep 3
echo "Starting EarnApp..."
earnapp start
echo "EarnApp restarted at $(date)" >> /var/log/earnapp-restart.log
EOF

chmod +x /usr/local/bin/restart-earnapp.sh
echo "✓ Script utama dibuat di /usr/local/bin/restart-earnapp.sh"

echo "=== Membuat service systemd ==="
cat << 'EOF' > /etc/systemd/system/restart-earnapp.service
[Unit]
Description=Restart EarnApp Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/restart-earnapp.sh
EOF
echo "✓ Service file dibuat di /etc/systemd/system/restart-earnapp.service"

echo "=== Membuat timer systemd (tiap 2 jam) ==="
cat << 'EOF' > /etc/systemd/system/restart-earnapp.timer
[Unit]
Description=Run EarnApp restart every 2 hours

[Timer]
OnBootSec=5min
OnUnitActiveSec=2h
Unit=restart-earnapp.service

[Install]
WantedBy=timers.target
EOF
echo "✓ Timer file dibuat di /etc/systemd/system/restart-earnapp.timer"

echo "=== Mengaktifkan timer ==="
systemctl daemon-reload
systemctl enable restart-earnapp.timer
systemctl start restart-earnapp.timer

echo "=== Selesai ==="
systemctl list-timers --all | grep restart-earnapp.timer
echo ""
echo "✅ Auto restart EarnApp aktif tiap 2 jam."
echo "Log disimpan di: /var/log/earnapp-restart.log"
