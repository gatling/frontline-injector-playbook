# Gatling Enterprise Injectors

## Content description

| Scripts  | Description |
| :------------- | :------------- |
| `build-aws-x86-zulu.sh`  | build java with kernel 5.x from Zulu distribution for x86_64 on aws |
| `build-aws-arm-zulu.sh`  | build java with kernel 5.x from Zulu distribution for arm on aws|
| `build-gcp-x86-zulu.sh`  | build java from Zulu distribution for x86_64 on gcp |
| `build-azure-x86-zulu.sh`  | build java from Zulu distribution for x86_64 on gcp |
| `ami-aws-snapshot-cleanup.sh`  | remove ami and associated snapshot on all regions  |

## Prerequisites

* Install `packer` version >= 1.7.8
* Install `aws` (AWS cli)
* Install `az` (Azure cli)
* Install `gcloud` (GCP cli)

## Build

### Github Action

| Action | Info | 
| :------------- | :------------- |
| [![AWS x86 java 17](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java17.yml) | AWS AMI x86 w/ java 17 |
| [![AWS arm java 17](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml) | AWS AMI arm w/ java 17 |
| [![AWS x86 java 11](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java11.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java11.yml)| AWS AMI x86 w/ java 11 |
| [![AWS x86 java 8](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java8.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java8.yml) | AWS AMI x86 w/ java 8 |
| [![.github/workflows/azure-x86-java17.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java17.yml) | Azure Gallery Images: `GatlingEnterpriseInjectors`<br />User input: [image_version](https://portal.azure.com/#@gatling.io/resource/subscriptions/4c3f1827-1a32-4d18-8e8e-c8abb129f0fe/resourceGroups/GatlingMarketPlace/providers/Microsoft.Compute/galleries/GatlingEnterpriseInjectors/images/classic-openjdk-17/overview) | 
| [![.github/workflows/azure-x86-java11.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java11.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java11.yml) | Azure Gallery Images: `GatlingEnterpriseInjectors`<br />User input: [image_version](https://portal.azure.com/#@gatling.io/resource/subscriptions/4c3f1827-1a32-4d18-8e8e-c8abb129f0fe/resourceGroups/GatlingMarketPlace/providers/Microsoft.Compute/galleries/GatlingEnterpriseInjectors/images/classic-openjdk-11/overview) |
| [![.github/workflows/azure-x86-java8.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java8.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java8.yml) | Azure Gallery Images: `GatlingEnterpriseInjectors`<br />User input: [image_version](https://portal.azure.com/#@gatling.io/resource/subscriptions/4c3f1827-1a32-4d18-8e8e-c8abb129f0fe/resourceGroups/GatlingMarketPlace/providers/Microsoft.Compute/galleries/GatlingEnterpriseInjectors/images/classic-openjdk-8/overview) |
| [![.github/workflows/gcp-x86-java17.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java17.yml) | FIXME |
| [![.github/workflows/gcp-x86-java11.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java11.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java11.yml) | FIXME |
| [![.github/workflows/gcp-x86-java8.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java8.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java8.yml) | FIXME |

### Manual

* [AWS](docs/aws.md)
* [GCP](docs/gcp.md)
* [Azure](docs/azure.md)

