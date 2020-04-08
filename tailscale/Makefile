REPOSITORY := "uesyn/tailscale"
TAG ?= "latest"
ROOT_DIR := $(shell pwd)

.PHYONY: build push

build:
	docker build -t $(REPOSITORY):$(TAG) $(ROOT_DIR)

push: build
	docker push $(REPOSITORY):$(TAG)
