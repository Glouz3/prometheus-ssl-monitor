#!/bin/bash

TARGET_FILE="./prometheus/targets/ssl_targets.json"
TLS_PORTS=(443 8443 993 995 465 6443 2379)

mkdir -p "$(dirname "$TARGET_FILE")"
> "$TARGET_FILE"

echo "[" >> "$TARGET_FILE"
count=0

for port in "${TLS_PORTS[@]}"; do
  timeout 1 bash -c "</dev/tcp/host.docker.internal/$port" &>/dev/null
  if [ $? -eq 0 ]; then
    [[ $count -gt 0 ]] && echo "," >> "$TARGET_FILE"
    echo "  { \"targets\": [ \"host.docker.internal:$port\" ] }" >> "$TARGET_FILE"
    ((count++))
  fi
done

echo "]" >> "$TARGET_FILE"

echo "Discovered $count TLS targets. Reloading Prometheus..."
curl -X POST http://localhost:9090/-/reload
