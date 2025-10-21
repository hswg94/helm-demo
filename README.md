# Nginx High Availability (HA) Helm Chart

A production-ready Helm chart that deploys a highly available nginx reverse proxy with 3 replicas, configurable upstream servers, and SSL/TLS support.

## Features

- **High Availability**: 3 nginx replicas for fault tolerance
- **Configurable Upstream Servers**: Easy backend server configuration
- **SSL/TLS Support**: Optional HTTPS with configurable certificates
- **Health Checks**: Built-in liveness and readiness probes
- **Load Balancing**: Automatic traffic distribution across replicas
- **Performance Optimized**: 8 worker processes, 4096 connections per worker

## Prerequisites

- Kubernetes cluster (Docker Desktop, Minikube, or cloud provider)
- Helm 3.x installed

## Installation Guide

### 1. Install Helm (Windows)

**Option A: Using Winget (Recommended)**
```powershell
winget install Helm.Helm
```

**Option B: Using Chocolatey**
```powershell
choco install kubernetes-helm
```

**Option C: Using Scoop**
```powershell
scoop install helm
```

**Option D: Manual Installation**
1. Download from [Helm Releases](https://github.com/helm/helm/releases)
2. Extract and add to PATH
3. Restart PowerShell

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

```powershell
# Navigate to the helm chart directory
cd c:\Users\HS\Desktop\helm-demo

# Install the chart
helm install helm-demo .

# Verify deployment
kubectl get pods
```

### 4. Access the Service

**Port Forward to Access Locally:**
```powershell
kubectl port-forward service/helm-demo-nginx-ha 8080:80
```

**Access via Browser:**
- HTTP: `http://localhost:8080`
- Custom Domain: `http://nginx-ha.local` (requires hosts file setup)

### 5. Setup Custom Domain (Optional)

**Add to Windows Hosts File:**
1. Open as Administrator: `C:\Windows\System32\drivers\etc\hosts`
2. Add line: `127.0.0.1 nginx-ha.local`
3. Save and close
4. Port forward to port 80: `kubectl port-forward service/helm-demo-nginx-ha 80:80`
5. Access: `http://nginx-ha.local`

## Configuration

### Basic Configuration (values.yaml)

```yaml
# Number of nginx replicas
replicaCount: 3

# Docker image settings
image:
  repository: nginx
  tag: "1.25.3"

# Service configuration
service:
  type: ClusterIP
  port: 80
  targetPort: 80

# Ingress settings
ingress:
  enabled: true
  host: nginx-ha.local
  tls:
    enabled: false

# Backend servers (configure your applications here)
upstreams:
  - name: backend_servers
    servers:
      - "192.168.1.100:3000"  # Replace with your backend IPs
      - "192.168.1.101:3000"
```

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

## Useful Commands

### Helm Operations

```powershell
# Install chart
helm install helm-demo .

# Upgrade deployment after configuration file modifications
helm upgrade helm-demo .

# Upgrade with custom values
helm upgrade helm-demo . --set replicaCount=5

# Uninstall chart
helm uninstall helm-demo

# Check deployment status
helm status helm-demo

# View deployment history
helm history helm-demo

# Rollback to previous version
helm rollback helm-demo 1
```

### Kubernetes Debugging

```powershell
# Check services status
kubectl get services

# Check pods status
kubectl get pods

# View pod logs
kubectl logs -l app.kubernetes.io/name=nginx-ha

# Describe service
kubectl describe service helm-demo-nginx-ha

# Check pod details
kubectl describe pods

# View configmap
kubectl get configmap helm-demo-nginx-ha-config -o yaml

# Port forward to specific pod
kubectl port-forward pod/POD-NAME 8080:8080
```

### Access and Testing

```powershell
# Port forward service
kubectl port-forward service/helm-demo-nginx-ha 8080:80

# Test with curl
curl http://localhost:8080

# Check which pod handled request
curl -I http://localhost:8080

# View pod information endpoint
curl http://localhost:8080/pod-info

# Health check endpoint
curl http://localhost:8080/health
```

### Load Balancing Testing

```powershell
# Test from inside cluster (shows real load balancing)
kubectl run test-pod --image=curlimages/curl -it --rm -- sh
# Inside pod: curl helm-demo-nginx-ha/pod-info (repeat multiple times)

# Force new connections (close browser between tests)
# Use different browsers or incognito windows
```

## Troubleshooting

### Common Issues

**1. Helm not found:**
```powershell
# Restart PowerShell after installation
# Or reload PATH: $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")
```

**2. Kubernetes cluster unreachable:**
```powershell
# Check cluster status
kubectl cluster-info

# For Docker Desktop: ensure Kubernetes is enabled
# For Minikube: minikube status
```

**3. Port forwarding fails:**
```powershell
# Check if service exists
kubectl get services

# Verify pods are running
kubectl get pods
```

**4. nginx-ha.local not accessible:**
- Ensure hosts file is updated correctly
- Use port 80 for port forwarding when using custom domain
- Or use localhost:8080 instead

**5. SSL certificate errors:**
- For development: disable SSL in values.yaml
- For production: set up proper certificates or use cert-manager

### Performance Tuning

```yaml
# High traffic configuration
replicaCount: 5

# Backend server configuration
upstreams:
  - name: backend_servers
    servers:
      - "backend1.example.com:3000"
      - "backend2.example.com:3000"
      - "backend3.example.com:3000"
```

## Uninstalling

### Complete Cleanup

```powershell
# Remove Helm deployment
helm uninstall helm-demo

# Remove any persistent volumes (if created)
kubectl delete pvc --all

# Verify cleanup
kubectl get all
```

### Remove Helm (if needed)

```powershell
# Using Winget
winget uninstall Helm.Helm

# Using Chocolatey
choco uninstall kubernetes-helm

# Using Scoop
scoop uninstall helm

# Manual: Remove from PATH and delete binary
```

## Notes

- **Port Forwarding**: Creates single connection - use cluster testing for real load balancing
- **SSL Certificates**: Self-signed certificates will show browser warnings
- **Backend Servers**: Update upstream servers in values.yaml to point to your actual applications
- **Health Checks**: Endpoints `/health` and `/pod-info` are available for monitoring
- **High Availability**: Automatic pod restart and traffic routing to healthy instances
- **Configuration**: All nginx settings are configurable through values.yaml
- **Scaling**: Easily scale replicas up/down with `--set replicaCount=N`

## Support

For issues or questions:
1. Check pod logs: `kubectl logs -l app.kubernetes.io/name=nginx-ha`
2. Verify configuration: `kubectl get configmap helm-demo-nginx-ha-config -o yaml`
3. Test connectivity: `kubectl port-forward` and `curl` commands above