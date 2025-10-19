#!/bin/bash
# Auto Installer: Restart EarnApp tiap 2 jam (hemat resource)
# Dibuat oleh LunaComp Hub

set -e

echo "=== [1/5] Membuat script utama restart EarnApp ==="
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

echo "=== [2/5] Membuat service systemd ==="
cat << 'EOF' > /etc/systemd/system/restart-earnapp.service
[Unit]
Description=Restart EarnApp Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/restart-earnapp.sh
EOF
echo "✓ Service dibuat di /etc/systemd/system/restart-earnapp.service"

echo "=== [3/5] Membuat timer tiap 1 jam ==="
cat << 'EOF' > /etc/systemd/system/restart-earnapp.timer
[Unit]
Description=Run EarnApp restart every 2 hours

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h
Unit=restart-earnapp.service

[Install]
WantedBy=timers.target
EOF
echo "✓ Timer dibuat di /etc/systemd/system/restart-earnapp.timer"

echo "=== [4/5] Mengaktifkan timer ==="
systemctl daemon-reload
systemctl enable restart-earnapp.timer
systemctl start restart-earnapp.timer
echo "✓ Timer aktif dan akan berjalan otomatis tiap 2 jam"

echo "=== [5/5] Tes restart pertama sekarang ==="
systemctl start restart-earnapp.service
sleep 2

echo ""
echo "=== STATUS SERVICE ==="
systemctl status restart-earnapp.service --no-pager

echo ""
echo "=== STATUS TIMER ==="
systemctl list-timers --all | grep restart-earnapp

echo ""
echo "=== LOG TERAKHIR ==="
tail -n 5 /var/log/earnapp-restart.log 2>/dev/null || echo "(belum ada log sebelumnya)"

echo ""
echo "✅ Instalasi selesai! EarnApp akan auto restart tiap 2 jam."
echo "Log: /var/log/earnapp-restart.log"
