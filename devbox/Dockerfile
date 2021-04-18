# devbox base

FROM debian:bullseye as base
ENV DEVBOX=true
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV GOMODCACHE=/tmp/gomodcache
ENV GOCACHE=/tmp/gocache
COPY apt-clean-install /bin/apt-clean-install
RUN apt update && \
	apt install -y --no-install-recommends \
	apt-transport-https \
	software-properties-common \
	dirmngr \
	gnupg \
	gnupg1 \
	gnupg2 && \
	apt-clean-install \
	automake libevent-dev libncurses-dev pkg-config bison \
	build-essential \
	ca-certificates \
	curl \
	dnsutils \
	dropbear \
	file \
	fuse \
	git \
	iproute2 \
	iptables \
	iputils-ping \
	less \
	locales \
	make \
	man \
	netcat \
	openssh-client \
	procps \
	socat \
	sudo \
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

FROM base as golang
ENV GO_VERSION=1.16.3
RUN curl -L https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH=/usr/local/go/bin:${PATH}

FROM base as rustup
ENV RUSTUP_HOME=/usr/local/rust/rustup
ENV CARGO_HOME=/usr/local/rust/cargo
ENV PATH=/usr/local/rust/cargo/bin:${PATH}
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

FROM base as tmux
RUN git clone https://github.com/tmux/tmux.git && \
    cd tmux && \
    git checkout 3.2 && \
    sh autogen.sh && \
    ./configure && \
    make && \
    mv tmux /usr/local/bin

# Commands

FROM golang:1.15 as go-cmd-downloader
COPY go-command-install /bin/go-command-install
RUN chmod +x /bin/go-command-install
RUN apt update && apt install -y jq unzip

FROM go-cmd-downloader as kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

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
ENV PATH=/usr/local/go/bin:${PATH}
COPY --from=golang /usr/local /usr/local
ENV RUSTUP_HOME=/usr/local/rust/rustup
ENV CARGO_HOME=/usr/local/rust/cargo
ENV PATH=/usr/local/rust/cargo/bin:${PATH}
COPY --from=rust /usr/local /usr/local
COPY --from=tmux /usr/local/bin/tmux /usr/local/bin/tmux
COPY --from=kubectl /usr/local/bin /usr/local/bin
COPY --from=neovim /usr/local/bin /usr/local/bin
COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
