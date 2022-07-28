FROM golang:1.13 as builder
ARG VERSION=v1.4.4
WORKDIR /usr/src
RUN git clone -b ${VERSION} https://github.com/FiloSottile/mkcert .
RUN go build -o /bin/mkcert -ldflags "-X main.Version=$(git describe --tags)"
RUN chmod +x /bin/mkcert

FROM debian:11-slim
COPY --from=builder /bin/mkcert /usr/local/bin/mkcert
RUN addgroup --gid 1000 mkcert && adduser --uid 1000 --gid 1000 --gecos "" --disabled-password mkcert
WORKDIR /home/mkcert
USER mkcert
ENTRYPOINT ["/usr/local/bin/mkcert"]
CMD ["-help"]
