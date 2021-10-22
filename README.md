# Gatling Enterprise Injector

## Prerequisites

* Install packer version >= 1.7.8
* Install aws cli with profile with ops and seller

```
# cat ~/.aws/config
[default]
region = eu-west-3

[profile seller]
region = eu-west-3
```

```
cat ~/.aws/credentials
[default]
aws_access_key_id = ACCESS_KEY_ID
aws_secret_access_key = SECRET_ACCESS_KEY

[seller]
aws_access_key_id = ACCESS_KEY_ID
aws_secret_access_key = SECRET_ACCESS_KEY
```

## Manual building

### AWS
#### arch: x86

```
# ./build-aws-x86-zulu.sh --help
usage: build-aws-x86-zulu --java-major MAJOR --copy-regions [true|false] --profile AWS_PROFILE [--help]

  --java-major        : Java major version
  --copy-regions      : true or false
  --profile           : AWS Profile
  --help              : This message
```

* Example: building and latest release of openjdk 17 on AWS for x64 architecture and copy AMI in all regions with AWS profile seller

```
# ./build-aws-x86-zulu.sh --java-major 17 --copy-region true --profile seller
2021-11-08 18:01:21 [INFO] Build Gatling Enterprise Injector x86_64 (build_id: e515)
2021-11-08 18:01:21 [INFO] AWS profile: seller
2021-11-08 18:01:21 [INFO] OpenJDK version: 17.0.1+12
2021-11-08 18:01:21 [INFO] Copy regions: [
 "eu-north-1",
 "ap-south-1",
 "eu-west-2",
 "eu-south-1",
 "eu-west-1",
 "ap-northeast-3",
 "ap-northeast-2",
 "ap-northeast-1",
 "sa-east-1",
 "ca-central-1",
 "ap-southeast-1",
 "ap-southeast-2",
 "eu-central-1",
 "us-east-1",
 "us-east-2",
 "us-west-1",
 "us-west-2"
]
...
```
