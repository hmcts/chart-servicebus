{{/*
All the common lables needed for the lables sections of the definitions.
*/}}
{{- define "hmcts.servicebus.labels" }}
app.kubernetes.io/name: {{ template "hmcts.servicebus.releaseName" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ template "hmcts.servicebus.releaseName" . }}
{{- end -}}

{{- define "hmcts.servicebus.releaseName" -}}
{{- if .Values.releaseNameOverride -}}
{{- tpl .Values.releaseNameOverride $ | trunc 53 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 53 -}}
{{- end -}}
{{- end -}}