# Nginx High Availability (HA) Helm Chart

A production-ready Helm chart that deploys a highly available nginx reverse proxy with 3 replicas, configurable upstream servers, and SSL/TLS support.

## Features

- **High Availability**: 3 nginx replicas for fault tolerance
- **Configurable Upstream Servers**: Easy backend server configuration
- **SSL/TLS Support**: Optional HTTPS with configurable certificates
- **Health Checks**: Built-in liveness and readiness probes
- **Load Balancing**: Automatic traffic distribution across replicas

## Prerequisites

- Kubernetes cluster (Docker Desktop, Minikube, or cloud provider)
- Helm 3.x installed

## Installation Guide

### 1. Install Helm (Windows)

**Option A: Using Winget (Recommended)**
```powershell
winget install Helm.Helm
```

### 2. Start Kubernetes Cluster

**Docker Desktop:**
1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"

**Minikube:**
```powershell
minikube start
```

### 3. Deploy the Helm Chart

# Install the chart
```powershell
helm install helm-demo .
```
# Verify deployment
```powershell
kubectl get services
```
```powershell
kubectl get pods
```

### 4. Setup Host Files (Optional)
**Add to Windows Hosts File:**
1. Open as Administrator: `C:\Windows\System32\drivers\etc\hosts`
2. Add line: `127.0.0.1 nginx-ha.local`
3. Access: `http://nginx-ha.local`

### 5. Access the Service Endpoints
- HTTP: `http://localhost:80`
- OR Custom Domain: `http://nginx-ha.local` (requires hosts file setup)

# View pod information endpoint
curl http://localhost:80/pod-info

# Health check endpoint
curl http://localhost:80/health
```

### Load Balancing Testing

```powershell
1..10 | ForEach-Object { Invoke-RestMethod http://localhost/pod-info }
```

```bash
for i in {1..10}; do curl -s http://localhost/pod-info; done
```

## Extra Configuration

### Enable HTTPS/SSL

```yaml
ingress:
  tls:
    enabled: true
    secretName: nginx-ha-tls
service:
  port: 443
  targetPort: 443
```