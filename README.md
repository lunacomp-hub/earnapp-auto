# earnapp-auto
menggunakan timer hingga irit resorce

1. 1. Buat script restart EarnApp

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
