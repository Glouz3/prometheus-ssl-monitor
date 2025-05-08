# Prometheus + Blackbox Exporter SSL Monitor
# prometheus-ssl-monitor

This repo provides a full Docker-based setup to monitor SSL certificate expiration dates using Prometheus and Blackbox Exporter.

## ✅ Features

- Automatically discovers TLS-enabled services on the host
- Monitors SSL certificate expiration via Blackbox Exporter
- Prometheus alerting for certificates expiring within 30 days

## 🚀 Usage

1. Clone the repo:
   ```bash
   git clone https://github.com/YOUR_USERNAME/prometheus-ssl-monitor.git
   cd prometheus-ssl-monitor
   
2. Run the discovery script:
    chmod +x discover_tls_services.sh
    ./discover_tls_services.sh
   
3. Start the stack:
    docker-compose up -d
   
4. Visit Prometheus at http://localhost:9090 and run:
    probe_ssl_earliest_cert_expiry  
