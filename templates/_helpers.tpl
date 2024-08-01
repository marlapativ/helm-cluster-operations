{{/*
Expand the name of the chart.
*/}}
{{- define "helm-cluster-operations.name" -}}
{{- default .Chart.Name .Values.nameOverride | trimPrefix "helm-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the istio namespace for the monitoring
*/}}
{{- define "helm-cluster-operations.monitoring.istio-namespace" -}}
{{- default .Release.Namespace .Values.istio.monitoring.namespace }}
{{- end }}

{{/*
Expand the istio namespace for the gateway
*/}}
{{- define "helm-cluster-operations.gateway.istio-namespace" -}}
{{- default .Release.Namespace .Values.istio.gateway.namespace }}
{{- end }}

{{/*
Expand the istio namespace for the certmanager
*/}}
{{- define "helm-cluster-operations.certmanager.namespace" -}}
{{- default .Release.Namespace .Values.certmanager.namespace }}
{{- end }}

{{/*
Set the acme server url for certmanager
*/}}
{{- define "helm-cluster-operations.certmanager.acmeserver" -}}
{{- if .Values.certmanager.acmeserver }}
{{- printf "%s" .Values.certmanager.acmeserver }}
{{- else }}
{{- if .Values.certmanager.staging }}
{{- printf "%s" "https://acme-staging-v02.api.letsencrypt.org/directory" }}
{{- else }}
{{- printf "%s" "https://acme-v02.api.letsencrypt.org/directory" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Set the certificate secret name
*/}}
{{- define "helm-cluster-operations.certificate.secretName" -}}
{{- if .Values.certificate.secretName }}
{{- printf "%s" .Values.certificate.secretName }}
{{- else }}
{{- printf "%s-certificate-secret" (include "helm-cluster-operations.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm-cluster-operations.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm-cluster-operations.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-cluster-operations.labels" -}}
helm.sh/chart: {{ include "helm-cluster-operations.chart" . }}
{{ include "helm-cluster-operations.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-cluster-operations.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-cluster-operations.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm-cluster-operations.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helm-cluster-operations.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
