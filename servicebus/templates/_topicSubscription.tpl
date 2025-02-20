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
  {{- include "hmcts.labels.v2" $base | indent 2 }}
spec:
  owner:
    name: {{ $computedTopicName }}
  azureName: {{ include "hmcts.releasename.v2" $base }}-{{ $topics.name }}
  requiresSession: {{ $topics.requiresSession | default false }}
{{- end }}
{{- end }}
