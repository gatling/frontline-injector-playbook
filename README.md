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

## Browser runtime

The `graalvm-browser` images are the GraalVM images plus what
[gatling-browser](https://github.com/gatling/gatling-browser) needs. GraalVM runs both JVM and JavaScript simulations, so
one flavor covers both. The `graalvm-openjdk` and Zulu images stay without a browser.

They're built by the `*-graal-browser-latest` workflows, i.e. the GraalVM build scripts with `--browser true`, which
runs `remote-script/05-browser-setup.sh` and names the images `graalvm-browser` instead of `graalvm-openjdk`:

- Node.js, from the official distribution, in `/opt/node`, for the Playwright driver, instead of the one bundled in
  Playwright's `driver-bundle` jar. Keep `NODE_VERSION` on the latest patch of the Node.js major bundled by Playwright.
- Chrome Headless Shell, in `/opt/ms-playwright`, installed by the Playwright CLI. Each Playwright version requires one
  browser revision and downloads are disabled: `PLAYWRIGHT_VERSION` must be the `playwright-core` version of the
  Playwright driver used by gatling-browser, and must be upgraded here before gatling-browser upgrades Playwright.
- Their libraries, fontconfig and the Liberation fonts, from the distribution packages.

The script sets `PLAYWRIGHT_NODEJS_PATH`, `PLAYWRIGHT_BROWSERS_PATH` and `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD` in
`/etc/profile.d/gatling-browser.sh` and `/etc/environment`. Processes started by cloud-init read neither: the load
generator startup script must source `/etc/profile.d/gatling-browser.sh`.

On Azure, the `gei-graalvm-browser-<java major>-prod-vid` image definition must exist in the `gei_prod_acg` gallery.

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
