FROM alpine:3.8

ARG VERSION=0.49.0
ENV TZ=Asia/Shanghai
WORKDIR /

COPY docker-entrypoint.sh /

RUN apk add --no-cache tzdata curl \
    && chmod +x /docker-entrypoint.sh \
    && if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM=amd64 ; else if [ "$(uname -m)" = "aarch64" ]; then export PLATFORM=arm64 ; fi fi \
	&& cd /srv/ \
    && curl -L -o frp_${VERSION}_linux_${PLATFORM}.tar.gz https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_${PLATFORM}.tar.gz \
	&& tar -xzf frp_${VERSION}_linux_${PLATFORM}.tar.gz \
	&& mkdir -p /frp/conf \
	&& cd frp_${VERSION}_linux_${PLATFORM} \
	&& mv frps frpc /usr/bin/ \
    && mkdir -p /etc/frp \
    && mv frps.ini frps_full.ini frpc.ini frpc_full.ini /etc/frp/ \
    && cd .. \
	&& rm -rf *.tar.gz frp_${VERSION}_linux_${PLATFORM}

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["frps","-c","/etc/frp/frps.ini"]