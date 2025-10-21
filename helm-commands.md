# Helm Commands Reference

## Initial Deployment
Install the Helm chart for the first time:
```powershell
helm install helm-demo .
```

## Updating/Upgrading
Update your deployment after making changes to the chart:
```powershell
helm upgrade helm-demo .
```

## Update with New Values
Change configuration values during upgrade:
```powershell
# Change replica count
helm upgrade helm-demo . --set replicaCount=5

# Enable SSL/TLS
helm upgrade helm-demo . --set ingress.tls.enabled=true

# Change upstream servers
helm upgrade helm-demo . --set upstreams[0].servers[0]="new-server:3000"
```

## Update with Values File
Use a different values file:
```powershell
helm upgrade helm-demo . -f values.yaml
helm upgrade helm-demo . -f production-values.yaml
```

## Management Commands

### List All Releases
```powershell
helm list
```

### Check Release Status
```powershell
helm status helm-demo
```

### View Release History
```powershell
helm history helm-demo
```

### Rollback to Previous Version
```powershell
# Rollback to previous revision
helm rollback helm-demo

# Rollback to specific revision
helm rollback helm-demo 1
```

## Uninstallation
Remove the deployment completely:
```powershell
helm uninstall helm-demo
```

## Accessing Your Application

### Port Forward (Easiest)
```powershell
kubectl port-forward service/helm-demo-nginx-ha 8080:80
```
Then access: `http://localhost:8080`

### Using Custom Domain (Requires hosts file)
1. Add to `C:\Windows\System32\drivers\etc\hosts`:
   ```
   127.0.0.1 nginx-ha.local
   ```
2. Port forward to port 80:
   ```powershell
   kubectl port-forward service/helm-demo-nginx-ha 80:80
   ```
3. Access: `http://nginx-ha.local`

## Debugging Commands

### Check Pods Status
```powershell
kubectl get pods -l app=nginx-ha
```

### Check Services
```powershell
kubectl get services
```

### Check Ingress
```powershell
kubectl get ingress
```

### View Pod Logs
```powershell
kubectl logs -l app=nginx-ha
```

### Describe Resources
```powershell
kubectl describe deployment helm-demo-nginx-ha
kubectl describe service helm-demo-nginx-ha
kubectl describe ingress helm-demo-nginx-ha
```

## Template Testing
Test your templates without deploying:
```powershell
# Render templates locally
helm template helm-demo .

# Validate chart
helm lint .

# Dry run installation
helm install helm-demo . --dry-run --debug
```

## Configuration Examples

### High Availability Setup
```yaml
# values-ha.yaml
replicaCount: 5
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Production with SSL
```yaml
# values-prod.yaml
ingress:
  enabled: true
  host: nginx.company.com
  tls:
    enabled: true

upstreams:
  - name: backend_servers
    servers:
      - "prod-server1:5000"
      - "prod-server2:5000"
      - "prod-server3:5000"
```

Deploy with:
```powershell
helm upgrade helm-demo . -f values-prod.yaml
```