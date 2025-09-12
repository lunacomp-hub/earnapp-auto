# earnapp-auto
menggunakan timer hingga irit resorce

1.Buat script restart EarnApp
Simpan di /usr/local/bin/restart-earnapp.sh
```
#!/bin/bash
# Restart EarnApp sekali jalan

echo "Stopping EarnApp..."
earnapp stop
sleep 3
echo "Starting EarnApp..."
earnapp start
echo "EarnApp restarted at $(date)" >> /var/log/earnapp-restart.log
```
Kasih izin eksekusi:
```
chmod +x /usr/local/bin/restart-earnapp.sh
```
2. Buat systemd service
File: /etc/systemd/system/restart-earnapp.service
```
[Unit]
Description=Restart EarnApp Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/restart-earnapp.sh
```
3. Buat systemd timer
File: /etc/systemd/system/restart-earnapp.timer
```
[Unit]
Description=Run EarnApp restart every 2 hours

[Timer]
OnBootSec=5min
OnUnitActiveSec=2h
Unit=restart-earnapp.service

[Install]
WantedBy=timers.target
```
4. Aktifkan timer
```
sudo systemctl daemon-reload
sudo systemctl enable restart-earnapp.timer
sudo systemctl start restart-earnapp.timer
```
5. Cek status timer
```
systemctl list-timers | grep earnapp
```
⚡ Dengan cara ini:

EarnApp akan restart otomatis tiap 2 jam
Tidak pakai loop, jadi lebih ringan
Jalan otomatis setelah boot
👉 Mau saya tambahkan juga opsi manual jalankan kapan saja denga:

```
systemctl restart restart-earnapp.service
```
