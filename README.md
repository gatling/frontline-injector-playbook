# Gatling Enterprise Injectors

## Policies

* [Azure Resource Naming Convention](https://gatlingcorp.atlassian.net/wiki/spaces/DEV/pages/2427715585/Azure+Resource+Naming+Convention)

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
| [![AWS arm java latest](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java-latest.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java-latest.yml) | AWS AMI x86 w/ java latest |
| [![AWS x86 java latest](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java-latest.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java-latest.yml) | AWS AMI x86 w/ java latest |
| [![AWS arm java 19](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java19.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml) | AWS AMI x86 w/ java 19 |
| [![AWS x86 java 19](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java19.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java19.yml) | AWS AMI x86 w/ java 19 |
| [![AWS x86 java 17](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java17.yml) | AWS AMI x86 w/ java 17 |
| [![AWS arm java 17](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml) | AWS AMI arm w/ java 17 |
| [![AWS x86 java 11](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java11.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java11.yml)| AWS AMI x86 w/ java 11 |
| [![AWS x86 java 8](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java8.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java8.yml) | AWS AMI x86 w/ java 8 |
| [![.github/workflows/azure-x86-java17.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java17.yml) | Azure Gallery Images: `gei_prod_agc` | 
| [![.github/workflows/azure-x86-java11.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java11.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java11.yml) | Azure Gallery Images: `gei_prod_agc` |
| [![.github/workflows/azure-x86-java8.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java8.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/azure-x86-java8.yml) | Azure Gallery Images: `gei_prod_agc` |
| [![.github/workflows/gcp-x86-java-latest.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java-latest.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java-latest.yml) | Image GCP w/ Java latest |
| [![.github/workflows/gcp-x86-java19.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java19.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java19.yml) | Image GCP w/ Java 19 |
| [![.github/workflows/gcp-x86-java17.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java17.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java17.yml) | Image GCP w/ Java 17 |
| [![.github/workflows/gcp-x86-java11.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java11.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java11.yml) | Image GCP w/ Java 11 |
| [![.github/workflows/gcp-x86-java8.yml](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java8.yml/badge.svg)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/gcp-x86-java8.yml) | Image GCP w/ Java 8 |

### Manual

* [AWS](docs/aws.md)
* [GCP](docs/gcp.md)
* [Azure](docs/azure.md)
