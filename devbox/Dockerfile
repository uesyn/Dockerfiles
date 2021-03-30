# devbox base

FROM debian:bullseye as base
ENV DEVBOX=true
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV GOMODCACHE=/tmp/gomodcache
ENV GOCACHE=/tmp/gocache
ENV OPT_DIR=/opt
COPY apt-clean-install /bin/apt-clean-install
RUN apt update && \
	apt install -y --no-install-recommends \
	apt-transport-https \
	software-properties-common \
	dirmngr \
	gnupg \
	gnupg1 \
	gnupg2 && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 && \
	apt-add-repository https://cli.github.com/packages && \
	apt-clean-install build-essential \
	ca-certificates \
	curl \
	dnsutils \
	dropbear \
	file \
	fuse \
	git \
	gh \
	iproute2 \
	iptables \
	iputils-ping \
	jq \
	less \
	locales \
	make \
	man \
	netcat \
	openssh-client \
	procps \
	ripgrep \
	socat \
	sudo \
	tmux \
	universal-ctags \
	unzip \
	rsync \
	wget \
	zsh
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash - && \
	apt-clean-install nodejs
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" >> /etc/apt/sources.list.d/google-cloud-sdk.list && \
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
	apt-clean-install google-cloud-sdk
RUN sed -ie "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen && locale-gen en_US.UTF-8

FROM base as docker
ENV VERSION 20.10.2
RUN curl -L -o docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${VERSION}.tgz && \
	tar xzvf docker.tgz --strip-component=1 -C /usr/local/bin
RUN chmod +x /usr/local/bin/docker

# Languages
# FROM base as rust-lang
# ENV RUSTUP_HOME=/opt/rust/rustup
# ENV CARGO_HOME=/opt/rust/cargo
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none --no-modify-path
# 
# FROM base as golang
# ENV GO_VERSION=1.15.8
# RUN curl -L https://golang.org/dl/go1.15.8.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# Commands

FROM golang:1.15 as go-cmd-downloader
COPY go-command-install /bin/go-command-install
RUN chmod +x /bin/go-command-install
RUN apt update && apt install -y jq unzip

FROM go-cmd-downloader as fzf
RUN URL=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep amd64) && \
	curl -o fzf.tar.gz -L $URL && \
	tar xf fzf.tar.gz && \
	mv fzf /usr/local/bin/fzf

FROM go-cmd-downloader as direnv 
RUN URL=$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep amd64) && \
	curl -o direnv -L $URL && \
	chmod +x direnv && \
	mv direnv /usr/local/bin/direnv

FROM go-cmd-downloader as stern
RUN URL=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep amd64) && \
	curl -L $URL | tar xzf - --strip-components=1 && \
	chmod +x stern && \
	mv stern /usr/local/bin/stern

FROM go-cmd-downloader as kubectx
RUN URL=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep x86_64 | grep kubectx_) && \
	curl -L $URL | tar xzf - && \
	chmod +x kubectx && \
	mv kubectx /usr/local/bin/kubectx
RUN URL=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep x86_64 | grep kubens_) && \
	curl -L $URL | tar xzf - && \
	chmod +x kubens && \
	mv kubens /usr/local/bin/kubens

FROM go-cmd-downloader as kind
RUN URL=$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep amd64) && \
	curl -o kind -L $URL && \
	chmod +x kind && \
	mv kind /usr/local/bin/kind

FROM go-cmd-downloader as ghq 
RUN URL=$(curl -s https://api.github.com/repos/x-motemen/ghq/releases/latest | jq -r '.assets[].browser_download_url' | grep $(uname | tr '[A-Z]' '[a-z]') | grep amd64) && \
	curl -o ghq.zip -L $URL && \
	unzip ghq.zip && \
	chmod +x ghq_linux_amd64/ghq && \
	mv ghq_linux_amd64/ghq /usr/local/bin/ghq

FROM go-cmd-downloader as kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

FROM go-cmd-downloader as gopls
RUN go-command-install golang.org/x/tools/gopls@latest /usr/local/bin

FROM base as neovim
RUN curl -o /usr/local/bin/nvim -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
RUN chmod +x /usr/local/bin/nvim

# brew
FROM base as brew
RUN useradd -m -s /bin/bash linuxbrew
RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
RUN mkdir /home/linuxbrew/.linuxbrew/bin
RUN ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/
RUN chmod 777 -R /home/linuxbrew/.linuxbrew

FROM base
COPY apt-clean-install /bin/apt-clean-install
RUN useradd -m -s /bin/bash linuxbrew
COPY --from=brew /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=fzf /usr/local/bin /usr/local/bin
COPY --from=direnv /usr/local/bin /usr/local/bin
COPY --from=gopls /usr/local/bin /usr/local/bin
COPY --from=kubectx /usr/local/bin /usr/local/bin
COPY --from=kubectl /usr/local/bin /usr/local/bin
COPY --from=kind /usr/local/bin /usr/local/bin
COPY --from=ghq /usr/local/bin /usr/local/bin
COPY --from=stern /usr/local/bin /usr/local/bin
COPY --from=neovim /usr/local/bin /usr/local/bin
COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
