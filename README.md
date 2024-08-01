# CSYE7125 Helm charts for Cluster Operations

This repository contains Helm chart designed to deploy istio, cert-manager custom resources for cluster operations

## Helm Installation

Please follow the installation instructions required for setting up the project [here](INSTALLATION.md).

## Chart Structure

The chart contains the following key files:

- `Chart.yaml`: Contains metadata for the chart.
- `values.yaml`: Contains default values for the chart.
- `templates/`: Contains the template files for the chart.
- `templates/cert-manager-certificate.yaml`: Contains the custom resource for cert-manager Certificate.
- `templates/cert-manager-clusterissuer.yaml`: Contains the custom resource for cert-manager ClusterIssuer.
- `templates/cert-manager-zerossl.yaml`: Contains the custom resource for cert-manager zero ssl custom configuration.
- `templates/istio-gateway.yaml`: Contains the custom resource for istio Gateway.
- `templates/istio-virtualservice.yaml`: Contains the custom resource for istio VirtualService.
- `templates/istio-podmonitor.yaml`: Contains the custom resource for istio PodMonitor.
- `templates/istio-servicemonitor.yaml`: Contains the custom resource for istio ServiceEntry.

## Installation

To install the chart with default variables set in `values.yaml`, execute the command:

```bash
helm install cluster-operations .
```

This will install the chart with the default values set in `values.yaml` in the `default` namespace.

## Uninstallation

To uninstall the chart, use the following command:

```bash
helm uninstall cluster-operations
```

## Configuration

The following table lists the configurable parameters of the Helm chart and their default values.
| Parameter                                | Description                                            | Default                 |
| ---------------------------------------- | ------------------------------------------------------ | ----------------------- |
| `istio.monitoring.namespace`             | Namespace for istio pod monitor and service monitor CR | `""`                    |
| `istio.monitoring.namespaceSelector.any` | Namespace selector for monitoring                      | `true`                  |
| `istio.monitoring.service.targetLabels`  | Target labels for service monitor                      | `["app"]`               |
| `istio.gateway.namespace`                | Namespace for istio gateway CR                         | `""`                    |
| `istio.gateway.selector.istio`           | Selector for Istio Ingress Gateway pods                | `gateway`               |
| `istio.gateway.servers`                  | Servers configuration for Istio Ingress Gateway        | `[]`                    |
| `istio.gateway.virtualservice.hosts`     | Hosts for virtualservice                               | `["*"]`                 |
| `istio.gateway.virtualservice.http`      | HTTP routes for virtualservice                         | See `values.yaml`       |
| `certmanager.namespace`                  | Namespace for cert-manager                             | `""`                    |
| `certmanager.email`                      | Email for cert-manager ClusterIssuer                   | `[]`                    |
| `certmanager.acmeserver`                 | ACME server for cert-manager ClusterIssuer             | `""`                    |
| `certmanager.zerossl.keyID`              | ZeroSSL EAB HMAC key ID                                | `""`                    |
| `certmanager.zerossl.key`                | ZeroSSL EAB HMAC key                                   | `""`                    |
| `certmanager.staging`                    | Use Let's Encrypt staging server                       | `true`                  |
| `certmanager.providers.route53.region`   | AWS region for Route53 DNS01 provider                  | `us-east-1`             |
| `certificate.dnsNames`                   | DNS names for cert-manager Certificate                 | `["localhost"]`         |
| `certificate.secretName`                 | Secret name for cert-manager Certificate               | `"ingress-certificate"` |
