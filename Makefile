ARCH := $(shell uname -m)
PLATFORM := $(shell uname -s)

dist := dist
image := oscarzhou/gentls:latest
pwd := $(shell pwd)

.PHONY: help 

help:
	@echo "Available targets:"
	@echo "  dev						: Generate certificates for development"
	@echo "  build						: Build docker image"
	@echo "  push						: Push docker image"
	@echo "  run 						: Run the docker container"
	@echo "  inspect 					: Inspect the docker container"
	@echo "  clean						: Clean up certificates folder"

dev:
	./gen-tls.sh debug

build: 
	docker build --progress=plain -t $(image) -f Dockerfile .

push:
	docker image push $(image)

# You need to change CN to your own IP address for make run
run:
	docker rm -f gentls
	docker run -v $(pwd)/certs:/data -e CN="172.17.221.208" --name gentls $(image)

inspect:
	docker rm -f gentls
	docker run -it -v $(pwd)/certs:/data --name gentls $(image) /bin/sh 

clean:
	rm -rf ./certificates
	sudo rm -rf ./certs