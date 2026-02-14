#!/bin/bash

set -e

echo "===== UPDATE & UPGRADE SYSTEM ====="
dpkg --configure -a
apt update && apt upgrade -y

echo "===== INSTALL DEPENDENCY INITRAMFS & ARMBIAN BSP ====="
apt install -y \
  initramfs-tools \
  initramfs-tools-core \
  initramfs-tools-bin \
  armbian-bsp-cli-odroidn2-current \
  u-boot-tools \
  --allow-downgrades \
  --allow-change-held-packages

echo "===== INSTALL DOCKER ====="
if ! command -v docker &> /dev/null; then
  apt install docker.io -y
  systemctl enable docker
  systemctl start docker
else
  echo "Docker sudah terinstall"
fi

echo "===== HAPUS SEMUA CONTAINER LAMA ====="
if [ "$(docker ps -aq)" ]; then
  docker rm -f $(docker ps -aq)
else
  echo "Tidak ada container untuk dihapus"
fi

echo "===== PULL IMAGE EARNAPP ====="
docker pull fazalfarhan01/earnapp:lite-1.294.218

echo "===== JALANKAN CONTAINER EARNAPP ====="
docker run -d -e EARNAPP_UUID="sdk-node-e90fbfbce11f4b088f1ea011bb819b00" --name earnapp-stb-01 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-ff6fefa0e7524fc1b745b4e9aedc3dbd" --name earnapp-stb-02 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-a10a21255e3a40c097eceba2d19278af" --name earnapp-stb-03 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-e822350a377949bd911b3c215bbb40b5" --name earnapp-stb-04 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-52b2be11b8d245e3a444c8b3b92d6194" --name earnapp-stb-05 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-aadaa47e5f3f452c8dc1ba1bf49571fb" --name earnapp fazalfarhan01/earnapp:lite

echo "===== SET AUTO RESTART CONTAINER ====="
docker update --restart unless-stopped $(docker ps -aq)

echo "===== SELESAI ====="
docker ps
