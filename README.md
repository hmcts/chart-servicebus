# chart-servicebus

[![Build Status](https://dev.azure.com/hmcts/CNP/_apis/build/status/Helm%20Charts/chart-servicebus)](https://dev.azure.com/hmcts/CNP/_build/latest?definitionId=62)

This chart is intended for adding the azure service bus interaction to the application.

We will take small PRs and small features to this chart but more complicated needs should be handled in your own chart.

## Example configuration

```yaml
resourceGroup: "your application resource group"
setup:
  queues:
   - name: yourQueue
  topics:
   - name: myTopic
```

**NOTE**: the queue and the resource group are required for the service bus to provision the queues and instance required for the application.

## Using it in your helm chart.
To get the connectionString needed in your application we need to use the secret connection string that is only available once the queue is provisioned.
This means that the secret made during the provisioning has to be available.
To access the connection string secret for the desired queue we can use this snippet in your values.template.yaml:

In the **Java** chart section under the `secrets:` section.
```yaml
servicebus:
    resourceGroup: yyyy
    setup:
      queues:
      - name: yourQueue
java:
  secrets:
    SB_CONN_STRING:
      secretRef: servicebus-secret-queue-{{ .Release.Name }}-servicebus-yourQueue
      key: connectionString
    SB_TOPIC_CONN_STRING:
      secretRef: servicebus-secret-topic-{{ .Release.Name }}-servicebus-yourTopic
      key: connectionString
```
If using releaseNameOverride, secretRef will be updated as in below
```yaml
releaseNameOverride: example-release-name
servicebus:
    resourceGroup: yyyy
    setup:
      queues:
      - name: yourQueue
java:
  secrets:
    SB_CONN_STRING:
      secretRef: servicebus-secret-queue-example-release-name-servicebus-yourQueue
```

Where:
 - **yourQueue** is your queue name.
 - **yyyy** is your application resource group.

## Configuration

The following table lists the configurable parameters of the Java chart and their default values.

| Parameter                         | Type | Description                                                                                                                                                                                                                                                                                                                              | Default                                   |
|-----------------------------------| ---- |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| `releaseNameOverride`             | Will override the resource name - It supports templating, example:`releaseNameOverride: {{ .Release.Name }}-my-custom-name`      | `Release.Name-Chart.Name`                                                                                                                                                                                                                                                                                                                |
| `location`                        | string | location of the PaaS instance of the servicebus to use                                                                                                                                                                                                                                                                                   | `uksouth`                                 |
| `serviceplan`                     | string | service plan of the PaaS instance to use                                                                                                                                                                                                                                                                                                 | `basic`                                   |
| `resourceGroup`                   | string | This is the resource group required for the azure deployment                                                                                                                                                                                                                                                                             | **Required**                              |
| `setup`                           | array | see the full description of the setup objects in [setup objects](#setupobjects)                                                                                                                                                                                                                                                          | **Required**                              |
| `setup.queues.name`               | `string` | The name of the queue.                                                                                                                                                                                                                                                                                                                   | **Required**                              |
| `setup.queues.maxQueueSize`       | `int` | The maximum size of the queue in megabytes, which is the size of memory allocated for the queue.                                                                                                                                                                                                                                         | 1024                                      |
| `setup.queues.messageTimeToLive`  | `string` | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. For example, `PT276H13M14S` sets the message to expire in 11 day 12 hour 13 minute 14 seconds. | "PT336H"                                  |
| `setup.queues.lockDuration`       | `string` | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The lock duration time window can range from 5 seconds to 5 minutes. For example, `PT2M30S` sets the lock duration time to 2 minutes 30 seconds.                                                                  | "PT30S"                                   |
| `setup.topics.name`               | `string` | The name of the topic.                                                                                                                                                                                                                                                                                                                   | **Required**                              |
| `setup.topics.maxTopicSize`       | `int` | The maximum size of the queue in megabytes, which is the size of memory allocated for the topic.                                                                                                                                                                                                                                         | 1024                                      |
| `setup.topics.messageTimeToLive`  | `string` | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. For example, `PT276H13M14S` sets the message to expire in 11 day 12 hour 13 minute 14 seconds. | "PT336H"                                  |
| `setup.topics.subscriptionNeeded` | `string` | Specifies whether to create a subscription in the topic. Valid values are ["yes", "no"]. If set to "yes", a subscription having random name will be created in the topic; otherwise, it leaves everything unchanged. You may set this field to "yes" for message consumer, and set this field to "no" for message producer.              | "no"                                      |
| `tags.teamName`                   | string | team name used to create related Azure tag. This will usually be set by Jenkins through `global.`                                                                                                                                                                                                                                        | **Required if not set through `global.`** |
| `tags.applicationName`            | string | application name used to create necessary Azure tag. This will usually be set by Jenkins through `global.`                                                                                                                                                                                                                               | **Required if not set through `global.`** |
| `tags.builtFrom`                  | string | built from used to create necessary Azure tag. This will usually be set by Jenkins through `global.`                                                                                                                                                                                                                                     | **Required if not set through `global.`** |
| `tags.businessArea`               | string | business area used to create necessary Azure tag. This will usually be set by Jenkins through `global.`                                                                                                                                                                                                                                  | **Required if not set through `global.`** |
| `tags.environment`                | string | environment used to create necessary Azure tag. This will usually be set by Jenkins through `global.`                                                                                                                                                                                                                                    | **Required if not set through `global.`**                          |

## Setup Objects
We support both `queue` and `topic` setup with optional `subscription` if needed.
 The queue object definition is:
```yaml
setup:
  queues:
  - name: yourQueue
    maxQueueSize:  1024 	
    messageTimeToLive: "PT336H" 
    lockDuration: "PT30S"
  topics:
  - name: yourTopic
    maxQueueSize:  1024 	
    messageTimeToLive: "PT336H" 
    subscriptionNeeded: "yes"

```

## Development and Testing

Default configuration (e.g. default image and ingress host) is setup for sandbox. This is suitable for local development and testing.

- Ensure you have logged in with `az cli` and are using `sandbox` subscription (use `az account show` to display the current one).
- For local development see the `Makefile` for available targets.
- To execute an end-to-end build, deploy and test run `make`.
- to clean up deployed releases, charts, test pods and local charts, run `make clean`

`helm test` will deploy a busybox container alongside the release which performs a simple HTTP request against the service health endpoint. If it doesn't return `HTTP 200` the test will fail. **NOTE:** it does NOT run with `--cleanup` so the test pod will be available for inspection.

## Azure DevOps Builds

Builds are run against the 'nonprod' AKS cluster.

### Pull Request Validation

A build is triggered when pull requests are created. This build will run `helm lint`, deploy the chart using `ci-values.yaml` and run `helm test`.

### Release Build

Triggered when the repository is tagged (e.g. when a release is created). Also performs linting and testing, and will publish the chart to ACR on success.
