#!/bin/bash

set -e

echo "===== UPDATE & UPGRADE SYSTEM ====="
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
docker run -d -e EARNAPP_UUID="sdk-node-73f6f824555e4a34bcc76472199dc47a" --name earnapp-stb-01 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-fd18f4b59c2944558ff516764e65bad0" --name earnapp-stb-02 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-44927e5d03b54f26bc2b7bfde18398f0" --name earnapp-stb-03 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-02647fe9c65a42a4ad642330d39897dd" --name earnapp-stb-04 fazalfarhan01/earnapp:lite
docker run -d -e EARNAPP_UUID="sdk-node-f95e8cc4da794851986bb5436d7eda81" --name earnapp fazalfarhan01/earnapp:lite

echo "===== SET AUTO RESTART CONTAINER ====="
docker update --restart unless-stopped $(docker ps -aq)

echo "===== SELESAI ====="
docker ps
