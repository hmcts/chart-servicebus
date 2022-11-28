{{- define "hmcts.servicebus.releaseName" -}}
{{- if .Values.releaseNameOverride -}}
{{- tpl .Values.releaseNameOverride $ | trunc 53 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 53 -}}
{{- end -}}
{{- end -}}