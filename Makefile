repo_base := ghcr.io/uesyn

image:
	docker build -t $(repo_base)/docker-bin -f Dockerfile-docker-bin .
	docker build -t $(repo_base)/linuxbrew -f Dockerfile-linuxbrew .

push:
	docker push $(repo_base)/docker-bin
	docker  $(repo_base)/linuxbrew
