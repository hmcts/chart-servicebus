{{- define "hmcts.topicSubscription" -}}
{{- $base := index . "base" -}}
{{- $topics := index . "topics" -}}
{{- $computedTopicName := index . "computedTopicName" -}}

{{- if $topics.subscriptionNeeded }}
---
apiVersion: servicebus.azure.com/v1api20211101
kind: NamespacesTopicsSubscription
metadata:
  name: {{ include "hmcts.releasename.v2" $base }}-{{ $topics.name }}
 {{- if $topics.ignoreSubscriptionDeletion }}
  annotations:
    "serviceoperator.azure.com/reconcile-policy": "detach-on-delete"
 {{- end }}
  {{- include "hmcts.labels.v2" $base | indent 2 }}
spec:
  owner:
    name: {{ $computedTopicName }}
  azureName: {{ include "hmcts.releasename.v2" $base }}-{{ $topics.name }}
  requiresSession: {{ $topics.requiresSession | default false }}
{{- if $topics.rules }}
  {{- range $rule := $topics.rules }}
---
    {{- include "hmcts.topicSubscriptionRule" (dict "base" $base "topics" $topics "rule" $rule) }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}