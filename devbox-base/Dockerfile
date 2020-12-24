FROM debian:buster as base
ENV DEVBOX=true \
	DEBIAN_FRONTEND=noninteractive \
	TZ=Asia/Tokyo \
	TERM=xterm-256color \
	LANG=en_US.UTF-8 \
	HOMEBREW_NO_AUTO_UPDATE=1
RUN set -x -e && \
  	apt update && apt install -y \
		kubectx make iptables zsh git man file curl tmux \
		wget sudo less locales ca-certificates iproute2 iputils-ping \
		dnsutils openssh-client build-essential procps software-properties-common && \
	sed -ie "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen && \
	locale-gen en_US.UTF-8 && \
	apt-get clean -y && rm -rf /var/lib/apt/lists/* /var/log/* /tmp/* /var/tmp/*
RUN update-alternatives --set iptables  /usr/sbin/iptables-legacy || true && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy || true && \
    update-alternatives --set arptables /usr/sbin/arptables-legacy || true



FROM golang:1.15 as gotools
RUN go get -u github.com/uesyn/clipboard/cmd/...
RUN go get -u github.com/mattn/memo
RUN go get -u golang.org/x/tools/cmd/goimports



FROM alpine as docker
ENV VERSION 19.03.9
RUN apk add curl
RUN curl -L -o docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${VERSION}.tgz && \
	    tar xzvf docker.tgz --strip-component=1 -C /usr/local/bin
RUN chmod +x /usr/local/bin/docker



FROM base
COPY docker-sudo /usr/local/bin/docker
COPY clean-brew-install /usr/local/bin/clean-brew-install
RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew && \
	mkdir /home/linuxbrew/.linuxbrew/bin && \
	ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/ && \
	chmod 777 -R /home/linuxbrew/.linuxbrew
RUN clean-brew-install asdf
RUN clean-brew-install ghq
RUN clean-brew-install hub
RUN clean-brew-install jq
RUN clean-brew-install golang
RUN clean-brew-install ripgrep
RUN clean-brew-install stern
RUN clean-brew-install kubectl
RUN clean-brew-install kind
RUN clean-brew-install vim
RUN clean-brew-install gh
RUN clean-brew-install fzf
RUN clean-brew-install direnv
COPY --from=gotools /go/bin /usr/local/bin
COPY --from=docker /usr/local/bin /usr/local/bin
RUN useradd -m -s /bin/bash devbox && echo "devbox ALL=NOPASSWD: ALL" >> /etc/sudoers
ENTRYPOINT ["/usr/local/bin/dockerd"]
