{{- define "hmcts.topicSubscriptionRule" -}}
{{- $base := index . "base" -}}
{{- $topics := index . "topics" -}}
{{- $rule := index . "rule" -}}
apiVersion: servicebus.azure.com/v1api20211101
kind: NamespacesTopicsSubscriptionsRule
metadata:
  name: {{ include "hmcts.releasename.v2" $base }}-{{ $rule.name }}
{{- if $topics.ignoreSubscriptionDeletion }}
  annotations:
    "serviceoperator.azure.com/reconcile-policy": "detach-on-delete"
{{- end }}
  {{- include "hmcts.labels.v2" $base | indent 2 }}
spec:
  owner:
    name: {{ include "hmcts.releasename.v2" $base }}-{{ $topics.name }}
  filterType: {{ $rule.filterType }}
  {{- if eq $rule.filterType "CorrelationFilter" }}
  correlationFilter:
    properties:
      {{- range $filter := $rule.correlationFilter }}
      "{{ $filter.name }}": "{{ $filter.value }}"
      {{- end }}
  {{- end }}
  {{- if eq $rule.filterType "SqlFilter" }}
  sqlFilter:
    {{- if hasKey $rule.sqlFilter "compatibilityLevel" }}
    compatibilityLevel: {{ $rule.sqlFilter.compatibilityLevel }}
    {{- end }}
    {{- if hasKey $rule.sqlFilter "requiresPreprocessing" }}
    requiresPreprocessing: {{ $rule.sqlFilter.requiresPreprocessing }}
    {{- end }}
    {{- if $rule.sqlFilter.sqlExpression }}
    sqlExpression: {{ $rule.sqlFilter.sqlExpression | quote }}
    {{- end }}
  {{- end }}
{{- end }}