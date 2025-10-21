# NGINX High Availability Helm Chart

This Helm chart deploys a highly available NGINX configuration with configurable upstream servers and SSL/TLS support for production environments.

## Features

- **High Availability**: 3 replica minimum with pod anti-affinity rules
- **Configurable Upstream Servers**: Easy configuration of backend servers
- **SSL/TLS Support**: Configurable SSL/TLS termination
- **Production Ready**: Includes resource limits, health checks, and monitoring
- **Security**: Pod security contexts, network policies, and RBAC
- **Scalability**: Horizontal Pod Autoscaler support
- **Resilience**: Pod Disruption Budget for controlled maintenance

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- (Optional) Ingress Controller for external access
- (Optional) Cert-Manager for automatic SSL certificate management

## Installation

### Basic Installation

```bash
helm install nginx-ha ./nginx-ha
```

### Installation with Custom Values

```bash
helm install nginx-ha ./nginx-ha -f custom-values.yaml
```

### Installation with SSL/TLS Enabled

```bash
# First, create the TLS secret
kubectl create secret tls nginx-ha-tls \
  --cert=path/to/tls.cert \
  --key=path/to/tls.key

# Then install with SSL enabled
helm install nginx-ha ./nginx-ha \
  --set nginx.ssl.enabled=true \
  --set ingress.tls.enabled=true
```

## Configuration

### Key Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of NGINX replicas | `3` |
| `nginx.upstreams` | Backend server configuration | See values.yaml |
| `nginx.ssl.enabled` | Enable SSL/TLS | `false` |
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.tls.enabled` | Enable TLS in ingress | `false` |
| `podDisruptionBudget.enabled` | Enable PDB | `true` |
| `autoscaling.enabled` | Enable HPA | `false` |

### Configuring Upstream Servers

Update the `nginx.upstreams` section in values.yaml:

```yaml
nginx:
  upstreams:
    - name: backend
      servers:
        - server: "backend1.example.com:443443"
          weight: 1
          max_fails: 3
          fail_timeout: "30s"
        - server: "backend2.example.com:443443"
          weight: 1
          max_fails: 3
          fail_timeout: "30s"
```

### Enabling SSL/TLS

1. Create a TLS secret:
```bash
kubectl create secret tls nginx-ha-tls \
  --cert=path/to/certificate.crt \
  --key=path/to/private.key
```

2. Enable SSL in values.yaml:
```yaml
nginx:
  ssl:
    enabled: true

ingress:
  tls:
    enabled: true
    hosts:
      - your-domain.com
```

### High Availability Configuration

The chart includes several HA features:

- **Pod Anti-Affinity**: Spreads pods across different nodes
- **Rolling Updates**: Zero-downtime deployments
- **Pod Disruption Budget**: Ensures minimum availability during maintenance
- **Health Checks**: Liveness and readiness probes
- **Resource Management**: CPU and memory limits/requests

### Scaling Configuration

Enable autoscaling:

```yaml
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 443
```

## Monitoring and Health Checks

The chart includes built-in health check endpoints:

- `/health` - Liveness probe endpoint
- `/ready` - Readiness probe endpoint

## Security Features

- **Pod Security Context**: Non-root user, read-only filesystem
- **Network Policies**: Control network traffic (optional)
- **Service Account**: Dedicated service account with minimal permissions
- **Security Context**: Dropped capabilities and restricted access

## Upgrading

To upgrade the deployment:

```bash
helm upgrade nginx-ha ./nginx-ha -f your-values.yaml
```

## Uninstallation

```bash
helm uninstall nginx-ha
```

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l app.kubernetes.io/name=nginx-ha
```

### View Logs
```bash
kubectl logs -l app.kubernetes.io/name=nginx-ha -f
```

### Check Configuration
```bash
kubectl get configmap nginx-ha-config -o yaml
```

### Test Connectivity
```bash
kubectl port-forward svc/nginx-ha 443443:443
curl http://localhost:443443/health
```

## Development

### Testing the Chart

```bash
# Template generation
helm template nginx-ha ./nginx-ha

# Lint the chart
helm lint ./nginx-ha

# Dry run installation
helm install nginx-ha ./nginx-ha --dry-run --debug
```

### Customization

You can customize the NGINX configuration by:

1. Modifying the `nginx` section in values.yaml
2. Adding custom configuration snippets
3. Mounting additional config files

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This Helm chart is licensed under the MIT License.

## Support

For support and questions:
- Create an issue in the repository
- Contact the DevOps team
- Check the troubleshooting section above