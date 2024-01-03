{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgresql-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "postgresql-operator.labels" -}}
helm.sh/chart: {{ include "postgresql-operator.chart" . }}
app.kubernetes.io/name: {{ include "postgresql-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Generate secret name for app user.
*/}}
{{- define "postgresql-operator.appUserSecret" -}}
{{- if and .Values.appUser.password .Values.appUser.username -}}
postgres-user
{{- end -}}
{{- end -}}

{{/*
Generate secret name for super user.
*/}}
{{- define "postgresql-operator.superUserSecret" -}}
{{- if and .Values.superUser.password .Values.superUser.username -}}
postgres-superuser
{{- end -}}
{{- end -}}

{{/*
Generate secret name for backup credentials.
*/}}
{{- define "postgresql-operator.backupCredsSecret" -}}
{{- if and .Values.backupCreds.accessKeyId .Values.backupCreds.secretAccessKey -}}
backup-creds
{{- end -}}
{{- end -}}
