{{- define "nginx-ha.fullname" -}}
{{- .Release.Name }}-{{ .Chart.Name }}
{{- end }}

{{- define "nginx-ha.labels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
{{- end }}

{{- define "nginx-ha.config" -}}
worker_processes 8;
events {
    worker_connections 4096;
}

http {
    server_names_hash_bucket_size 64;
    include mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    upstream backend_servers {
{{- range .Values.upstreams }}
{{- range .servers }}
        server {{ . }};
{{- end }}
{{- end }}
    }

    server {
        listen {{ .Values.service.targetPort }};
        server_name localhost;

        location /health {
            return 200 'healthy';
            access_log off;
        }

        location /pod-info {
            return 200 'Pod: $hostname\nIP: $server_addr\n';
            add_header Content-Type text/plain;
        }

        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            # Add pod identification headers
            add_header X-Pod-Name $hostname;
            add_header X-Pod-IP $server_addr;
        }
    }
}
{{- end }}