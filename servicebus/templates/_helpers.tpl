{{/*
All the common lables needed for the lables sections of the definitions.
*/}}
{{- define "labels" }}
app.kubernetes.io/name: {{ .Release.Name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name -}}
{{- end -}}

{{- define "hmcts.servicebus.releaseName" -}}
{{- if .Values.releaseNameOverride -}}
{{- tpl .Values.releaseNameOverride $ | trunc 53 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 53 -}}
{{- end -}}
{{- end -}}