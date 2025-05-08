#!/bin/bash

# Location for Prometheus file-based service discovery
TARGET_FILE="/etc/prometheus/targets/ssl_targets.json"

# Define common ports used by services with TLS
TLS_PORTS=(443 8443 993 995 465 6443 2379)

# Get IP address or hostname (assume localhost here)
HOSTNAME=$(hostname -f)

echo "Discovering TLS-enabled services on: $HOSTNAME"

# Find open TLS ports
open_tls_ports=()
for port in "${TLS_PORTS[@]}"; do
  timeout 1 bash -c "</dev/tcp/localhost/$port" &>/dev/null
  if [ $? -eq 0 ]; then
    open_tls_ports+=("$port")
  fi
done

# Create JSON target list
mkdir -p "$(dirname "$TARGET_FILE")"

echo "[" > "$TARGET_FILE"
for i in "${!open_tls_ports[@]}"; do
  port="${open_tls_ports[$i]}"
  sep=","
  [[ $i -eq $((${#open_tls_ports[@]} - 1)) ]] && sep=""
  echo "  { \"targets\": [ \"localhost:$port\" ] }$sep" >> "$TARGET_FILE"
done
echo "]" >> "$TARGET_FILE"

echo "Discovered targets written to $TARGET_FILE"
