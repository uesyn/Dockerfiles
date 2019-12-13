IMAGE := uesyn/wireguard
TAG := latest

.PHONY: build
build:
	@docker build -t $(IMAGE):$(TAG) .
.PHONY: push
push:
	@docker push $(IMAGE):$(TAG)
