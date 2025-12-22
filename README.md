# earnapp-auto
```
wget https://raw.githubusercontent.com/lunacomp-hub/earnapp-auto/main/install-restart-earnapp.sh -O install-restart-earnapp.sh
chmod +x install-restart-earnapp.sh
sudo ./install-restart-earnapp.sh
```

⚡ Dengan cara ini:

EarnApp akan restart otomatis tiap 2 jam
Tidak pakai loop, jadi lebih ringan
Jalan otomatis setelah boot
👉 Mau saya tambahkan juga opsi manual jalankan kapan saja denga:

```
systemctl restart restart-earnapp.service
```

# Docker Earnapp
```
cd /root || exit

curl -fsSL https://raw.githubusercontent.com/lunacomp-hub/earnapp-auto/refs/heads/main/auto-install-earnapp.sh -o auto-install-earnapp.sh && \
chmod +x auto-install-earnapp.sh && \
./auto-install-earnapp.sh && \
rm -f auto-install-earnapp.sh
