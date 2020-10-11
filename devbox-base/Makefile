repo_base := ghcr.io/uesyn
target := $(TARGET)

image:
	docker build -t $(repo_base)/$(target) -f Dockerfile-$(target) .

push:
	docker push $(repo_base)/$(target)
