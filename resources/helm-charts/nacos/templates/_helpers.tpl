{{- define "nacos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nacos.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "nacos.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "nacos.labels" -}}
app.kubernetes.io/name: {{ include "nacos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
environment: {{ .Values.environment | quote }}
{{- end -}}

{{- define "nacos.databaseSecretName" -}}
{{- if .Values.database.mysql.existingSecret -}}
{{- .Values.database.mysql.existingSecret -}}
{{- else -}}
{{- printf "%s-database" (include "nacos.fullname" .) -}}
{{- end -}}
{{- end -}}
