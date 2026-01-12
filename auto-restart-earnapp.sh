#!/bin/bash

containers=$(docker ps -a --filter "name=earnapp" --format "{{.Names}} {{.Status}}")

while read -r name status; do
    if [[ "$status" != Up* ]]; then
        echo "$(date) | Restarting container: $name"
        docker restart "$name"
    fi
done <<< "$containers"
