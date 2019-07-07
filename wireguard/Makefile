IMAGE := uesyn/wireguard
TAG := latest

.PHONY: all
all: build push

.PHONY: build
build:
	@docker build -t $(IMAGE):$(TAG) .
.PHONY: push
push:
	@docker push $(IMAGE):$(TAG)
