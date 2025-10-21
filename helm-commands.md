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