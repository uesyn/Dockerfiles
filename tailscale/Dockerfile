FROM golang:1.14-alpine AS build-env
RUN apk add git
RUN git clone https://github.com/tailscale/tailscale.git /go/src/tailscale
WORKDIR /go/src/tailscale
RUN go install -v ./cmd/...

FROM alpine:3.11
RUN apk add --no-cache ca-certificates iptables bash
COPY --from=build-env /go/bin/* /usr/local/bin/
COPY entrypoint /usr/local/bin/entrypoint
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
