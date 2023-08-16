FROM alpine:3.12

VOLUME [ "/data" ]

WORKDIR /gen-tls

COPY gen-tls.sh .
COPY bin ./bin

RUN chmod +x gen-tls.sh bin/*

CMD [ "/bin/sh", "-c", "/gen-tls/gen-tls.sh", "production" ]