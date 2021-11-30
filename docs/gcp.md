# GCP
## Manual building
### Prerequisites

* Install gcloud cli
* Download the credential file from 1password (GCP Packer Credentials - Gatling Enterprise Injectors)
* Setup `GOOGLE_APPLICATION_CREDENTIALS` variable in your env

```
export GOOGLE_APPLICATION_CREDENTIALS="PATH/gcp_credentials.json"
```

### arch: x86

```
# ./build-gcp-x86-zulu.sh --help
usage: ./build-gcp-x86-zulu.sh  --java-major MAJOR --copy-regions [true|false] [--help]

  --java-major        : Java major version
  --project-id        : GCP project id
  --help              : This message
```
