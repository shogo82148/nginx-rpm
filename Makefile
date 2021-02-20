SOURCE_ARCHIVE := nginx-1.19.5.tar.gz
TARGZ_FILE := nginx.tar.gz
IMAGE_NAME := nginx-package
amazonlinux2: IMAGE_NAME := $(IMAGE_NAME)-amazonlinux2

.PHONY: all clean amazonlinux2

all: amazonlinux2
amazonlinux2: amazonlinux2.build


rpmbuild/SOURCES/$(SOURCE_ARCHIVE):
	curl -SL http://nginx.org/download/$(SOURCE_ARCHIVE) -o rpmbuild/SOURCES/$(SOURCE_ARCHIVE)

%.build: Dockerfile.% rpmbuild/SPECS/nginx.spec rpmbuild/SOURCES/$(SOURCE_ARCHIVE) \
		rpmbuild/SOURCES/COPYRIGHT rpmbuild/SOURCES/logrotate rpmbuild/SOURCES/nginx-debug.service \
		rpmbuild/SOURCES/nginx-debug.sysconf rpmbuild/SOURCES/nginx.check-reload.sh rpmbuild/SOURCES/nginx.conf \
		rpmbuild/SOURCES/nginx.init.in rpmbuild/SOURCES/nginx.service rpmbuild/SOURCES/nginx.suse.logrotate \
		rpmbuild/SOURCES/nginx.sysconf rpmbuild/SOURCES/nginx.upgrade.sh rpmbuild/SOURCES/nginx.vh.default.conf
	./scripts/build.sh $*

.PHONY: upload
upload:
	./scripts/upload.pl

clean:
	rm -rf *.build.bak *.build bintray tmp Dockerfile
	docker images | grep -q $(IMAGE_NAME)-amazonlinux2 && docker rmi $(IMAGE_NAME)-amazonlinux2 || true
