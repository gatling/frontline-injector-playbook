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

| Action | Description | 
| :------------- | :------------- |
| [![AWS x86 java 17](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java17.yml/badge.svg?branch=install-zulu)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java17.yml) | FIXME |
| [![AWS arm java 17](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml/badge.svg?branch=install-zulu)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-arm-java17.yml) | FIXME |
| [![AWS x86 java 11](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java11.yml/badge.svg?branch=install-zulu)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java11.yml)| FIXME |
| [![AWS x86 java 8](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java8.yml/badge.svg?branch=install-zulu)](https://github.com/gatling/frontline-injector-playbook/actions/workflows/aws-x86-java8.yml) | FIXME |

### Manual

* [AWS](docs/aws.md)
* [GCP](docs/gcp.md)
* [Azure](docs/azure.md)

