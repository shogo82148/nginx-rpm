SOURCE_ARCHIVE := nginx-1.19.0.tar.gz
TARGZ_FILE := nginx.tar.gz
IMAGE_NAME := nginx-package
amazonlinux2: IMAGE_NAME := $(IMAGE_NAME)-amazonlinux2

.PHONY: all clean amazonlinux2 bintray

all: amazonlinux2
amazonlinux2: amazonlinux2.build


rpmbuild/SOURCES/$(SOURCE_ARCHIVE):
	curl -SL http://nginx.org/download/$(SOURCE_ARCHIVE) -o rpmbuild/SOURCES/$(SOURCE_ARCHIVE)

%.build: Dockerfile.% rpmbuild/SPECS/nginx.spec rpmbuild/SOURCES/$(SOURCE_ARCHIVE)
	[ -d $@.bak ] && rm -rf $@.bak || :
	[ -d $@ ] && mv $@ $@.bak || :
	tar -czf - Dockerfile.$* rpmbuild | docker build --file Dockerfile.$* -t $(IMAGE_NAME) -
	docker run --name $(IMAGE_NAME)-tmp $(IMAGE_NAME)
	mkdir -p tmp
	docker wait $(IMAGE_NAME)-tmp
	docker cp $(IMAGE_NAME)-tmp:/tmp/$(TARGZ_FILE) tmp
	docker rm $(IMAGE_NAME)-tmp
	mkdir $@
	tar -xzf tmp/$(TARGZ_FILE) -C $@
	rm -rf tmp Dockerfile
	docker images | grep -q $(IMAGE_NAME) && docker rmi $(IMAGE_NAME) || true

bintray:
	./scripts/build_bintray_json.bash \
		nginx \
		nginx-debuginfo

clean:
	rm -rf *.build.bak *.build bintray tmp Dockerfile
	docker images | grep -q $(IMAGE_NAME)-amazonlinux2 && docker rmi $(IMAGE_NAME)-amazonlinux2 || true
