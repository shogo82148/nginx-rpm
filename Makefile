SOURCE_ARCHIVE := nginx-1.21.4.tar.gz
TARGZ_FILE := nginx.tar.gz
IMAGE_NAME := nginx-package

.PHONY: all
all: amazonlinux2 centos7 centos8 almalinux8 rockylinux8

.PHONY: amazonlinux2
amazonlinux2: amazonlinux2.build

.PHONY: centos7
centos7: centos7.build

.PHONY: centos8
centos8: centos8.build

.PHONY: almalinux8
almalinux8: almalinux8.build

.PHONY: rockylinux8
rockylinux8: rockylinux8.build

rpmbuild/SOURCES/$(SOURCE_ARCHIVE):
	curl -SL https://nginx.org/download/$(SOURCE_ARCHIVE) -o rpmbuild/SOURCES/$(SOURCE_ARCHIVE)

%.build: Dockerfile.% rpmbuild/SPECS/nginx.spec rpmbuild/SOURCES/$(SOURCE_ARCHIVE) \
		rpmbuild/SOURCES/COPYRIGHT rpmbuild/SOURCES/logrotate rpmbuild/SOURCES/nginx-debug.service \
		rpmbuild/SOURCES/nginx-debug.sysconf rpmbuild/SOURCES/nginx.check-reload.sh rpmbuild/SOURCES/nginx.conf \
		rpmbuild/SOURCES/nginx.init.in rpmbuild/SOURCES/nginx.service rpmbuild/SOURCES/nginx.suse.logrotate \
		rpmbuild/SOURCES/nginx.sysconf rpmbuild/SOURCES/nginx.upgrade.sh rpmbuild/SOURCES/nginx.vh.default.conf
	./scripts/build.sh $*

.PHONY: upload
upload:
	./scripts/upload.pl

.PHONY: test
test: test-amazonlinux2 test-centos7 test-centos8 test-almalinux8 test-rockylinux8

.PHONY: test-amazonlinux2
test-amazonlinux2:
	./scripts/test.sh amazonlinux2

.PHONY: test-centos7
test-centos7:
	./scripts/test.sh centos7

.PHONY: test-centos8
test-centos8:
	./scripts/test.sh centos8

.PHONY: test-almalinux8
test-almalinux8:
	./scripts/test.sh almalinux8

.PHONY: test-rockylinux8
test-rockylinux8:
	./scripts/test.sh rockylinux8

clean:
	rm -rf *.build.bak *.build
	rm -rf rpmbuild/SOURCES/nginx-*.tar.gz
	docker rmi $(IMAGE_NAME)-amazonlinux2 || true
	docker rmi $(IMAGE_NAME)-centos7 || true
	docker rmi $(IMAGE_NAME)-centos8 || true
	docker rmi $(IMAGE_NAME)-almalinux8 || true
	docker rmi $(IMAGE_NAME)-rockylinux8 || true
