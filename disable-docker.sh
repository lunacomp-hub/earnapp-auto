#!/bin/bash

echo "== STOP semua container Docker =="
docker stop $(docker ps -q) 2>/dev/null

echo "== STOP service Docker =="
systemctl stop docker docker.socket

echo "== DISABLE Docker permanen =="
systemctl disable docker docker.socket

echo "== MASK Docker (biar tidak bisa jalan sama sekali) =="
systemctl mask docker docker.socket

echo "== STATUS Docker =="
systemctl status docker --no-pager

echo "SELESAI ✅ Docker sudah DIMATIKAN PERMANEN"
