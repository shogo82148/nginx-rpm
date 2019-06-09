nginx Unofficial RPM package builder
==================================

[![Build Status](https://travis-ci.com/shogo82148/nginx-rpm.svg?branch=master)](https://travis-ci.com/shogo82148/nginx-rpm)

It provides [nginx](https://www.nginx.com/) RPM spec file and required files to build RPM for Amazon Linux 2.

[Official packages](https://nginx.org/en/linux_packages.html) provide Red Hat/CentOS RPM,
while there is no RPM for Amazon Linux 2.
That's why I created this.


## How to use prebuilt RPM

To add NGINX yum repository, create a file named `/etc/yum.repos.d/bintray-shogo82148-nginx-rpm.repo.repo` and paste the configurations below:

```ini
#bintray-shogo82148-h2o-rpm - packages by shogo82148 from Bintray
[bintray-shogo82148-h2o-rpm]
name=bintray-shogo82148-h2o-rpm
baseurl=https://dl.bintray.com/shogo82148/nginx-rpm/amazonlinux2/$releasever/$basearch/
gpgcheck=0
repo_gpgcheck=1
enabled=1
gpgkey=https://bintray.com/api/v1/usrs/shogo82148/keys/gpg/public.key
```

Once the file is correctly saved, you can install packages in the repository by

```bash
rpm --import https://bintray.com/api/v1/usrs/shogo82148/keys/gpg/public.key
yum install nginx
```
