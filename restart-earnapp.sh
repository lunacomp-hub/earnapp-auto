#!/bin/bash
# Restart EarnApp sekali jalan

echo "Stopping EarnApp..."
earnapp stop
sleep 3
echo "Starting EarnApp..."
earnapp start
echo "EarnApp restarted at $(date)" >> /var/log/earnapp-restart.log
