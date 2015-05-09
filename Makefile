
IMAGE=alpine-python:2.7.6
USERNAME=aledbf
REPO=alpine-python-2.7.6
TAG=v0.0.1

build:
	docker build -t $(IMAGE) .
	docker cp `docker run -d $(IMAGE) /bin/sh`:/packages/x86_64/python-2.7.6-r4.apk pkg/
	docker cp `docker run -d $(IMAGE) /bin/sh`:/packages/x86_64/python-dev-2.7.6-r4.apk pkg/

release:
	tar -cvf release.tar pkg/python-2.7.6-r4.apk pkg/python-dev-2.7.6-r4.apk
	github-release upload \
    --user $(USERNAME) \
    --repo $(REPO) \
    --tag $(TAG) \
    --name "$(IMAGE" \
    --file release.tar
