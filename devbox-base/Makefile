repositry := ghcr.io/uesyn/devbox
target := $(TARGET)

image:
	DOCKER_BUILDKIT=1 docker build --squash -t $(repositry) -f Dockerfile .

push:
	docker push $(repositry)
