# nginx Unofficial RPM package builder

[![build](https://github.com/shogo82148/nginx-rpm/actions/workflows/build.yml/badge.svg)](https://github.com/shogo82148/nginx-rpm/actions/workflows/build.yml)

It provides [nginx](https://www.nginx.com/) RPM spec file and required files to build RPM for Amazon Linux 2.

[Official packages](https://nginx.org/en/linux_packages.html) provide Red Hat/CentOS RPM,
while there is no RPM for Amazon Linux 2.
That's why I created this.

## How to use prebuilt RPM

Once the file is correctly saved, you can install packages in the repository by

```bash
yum install nginx
```

### Amazon Linux 2

To add Fluent Bit yum repository, create a file named `/etc/yum.repos.d/shogo82148.repo`.

```ini
# shogo82148-rpm - packages by shogo82148
[shogo82148-rpm]
name=shogo82148-rpm
baseurl=https://shogo82148-rpm-repository.s3-ap-northeast-1.amazonaws.com/amazonlinux/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://shogo82148-rpm-repository.s3-ap-northeast-1.amazonaws.com/RPM-GPG-KEY-shogo82148
```

Or install the RPM package for configure the repository.

```
yum install -y https://shogo82148-rpm-repository.s3-ap-northeast-1.amazonaws.com/amazonlinux/2/noarch/shogo82148/shogo82148-1.0.0-1.amzn2.noarch.rpm
```
