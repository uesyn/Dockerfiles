repositry := ghcr.io/uesyn/devbox
target := $(TARGET)

image:
	docker build -t $(repositry) -f Dockerfile .

push:
	docker push $(repositry)
