#!/bin/sh

read -p "Enter the CN name: " CN

docker rm -f gentls
docker run -v $(pwd)/certs:/data -e CN="${CN}" --name gentls oscarzhou/gentls:latest

docker rm -f registry
docker run -d -p 5000:5000 --restart=always --name registry -v $(pwd)/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/server.pem \
    -e REGISTRY_HTTP_TLS_KEY=/certs/server-key.pem \
    registry:2
