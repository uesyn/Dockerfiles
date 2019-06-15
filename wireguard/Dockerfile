FROM ubuntu:18.10 as wg
RUN set -x -e && \
	apt-get update && \
    	apt-get install --no-install-recommends -y \
        build-essential \
	autoconf automake libtool pkg-config \
        curl \
        git \
	less \
        zip \
	libmnl-dev \
	ca-certificates 
RUN git clone https://github.com/WireGuard/WireGuard.git && \
	cd WireGuard/src && \
	make tools && \
	mv tools/wg /usr/local/bin

FROM golang:1.12 as wireguard-go
RUN set -x -e && \
	git clone https://git.zx2c4.com/wireguard-go && \
	cd wireguard-go	&& \
	make

FROM ubuntu:18.10
COPY --from=wg /usr/local/bin/wg /usr/local/bin/
COPY --from=wireguard-go /go/wireguard-go/wireguard-go /usr/local/bin/wireguard-go
ENV WG_I_PREFER_BUGGY_USERSPACE_TO_POLISHED_KMOD=1
RUN set -x -e && \
	apt-get update && \
    	apt-get install --no-install-recommends -y \
        curl \
        git \
	less \
	iproute2 \
	iptables \
	iputils-ping \
	ca-certificates
COPY entrypoint /

ENTRYPOINT [ "/entrypoint" ]
