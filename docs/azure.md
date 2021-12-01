# Azure
## Manual building
### Prerequisites

* Install Azure cli

### arch: x86

```
# ./build-azure-x86-zulu.sh --help
usage: ./build-azure-x86-zulu.sh  --java-major MAJOR --client-id CLIENT_ID --client-secret CLIENT_SECRET --subscription-id SUBSCRIPTION_ID --tenant-id TENANT_ID --image-version IMAGE_VERSION [--help]

  --java-major        : Java major version
  --client-id         : Azure Client ID
  --client-secret     : Azure Client Secret
  --subscription-id   : Azure Subscription ID
  --tenant-id         : Azure Tenant ID
  --image-version     : Azure Image Version
  --help              : This message
```

* Example: building latest release of openjdk 17 on Azure for x64 architecture

```
2021-11-30 09:29:36 [INFO] Build Gatling Enterprise Injector x86_64 (build_id: 5efa)
2021-11-30 09:29:36 [INFO] Image version: 1.0.0
2021-11-30 09:29:36 [INFO] OpenJDK version: 17.0.1+12
2021-11-30 09:29:36 [INFO] Client ID: 2cae34d1-ea4b-4449-a4e9-8fc4afa999f2
2021-11-30 09:29:36 [INFO] Subscription ID: 4c3f1827-1a32-4d18-8e8e-c8abb129f0fe
2021-11-30 09:29:36 [INFO] Tenant ID: c7d41398-26b2-4af9-854c-08b66b7d3215
azure-arm.x86_64: output will be in this color.

==> azure-arm.x86_64: Running builder ...
==> azure-arm.x86_64: Getting tokens using client secret
==> azure-arm.x86_64: Getting tokens using client secret
    azure-arm.x86_64: Creating Azure Resource Manager (ARM) client ...
==> azure-arm.x86_64: Getting source image id for the deployment ...
==> azure-arm.x86_64:  -> SourceImageName: '/subscriptions/4c3f1827-1a32-4d18-8e8e-c8abb129f0fe/providers/Microsoft.Compute/locations/westeurope/publishers/Debian/ArtifactTypes/vmimage/offers/debian-10/skus/10-backports/versions/latest'
==> azure-arm.x86_64: Creating resource group ...
==> azure-arm.x86_64:  -> ResourceGroupName : 'pkr-Resource-Group-idpf4u797z'
==> azure-arm.x86_64:  -> Location          : 'westeurope'
==> azure-arm.x86_64:  -> Tags              :
==> azure-arm.x86_64: Validating deployment template ...
...
```
