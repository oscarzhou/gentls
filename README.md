

# Instruction 

A docker image used to generate self-signed CA, Server and Client Certificates. 

## How to use? 

1. Mount your local directory to `/data` in the container.
2. Set the `CN` environment variable to your domain or ip address. If you use for localhost, you can set `CN` to your private ip address. If you use for your domain, you can set `CN` to your domain. If you want to add multiple domains, you can use comma to separate them.
3. Run the container.
4. The generated certificates will be in the mounted directory.

```
mkdir -p certs
docker run -v $(pwd)/certs:/data -e CN="example.com,182.12.23.144" --name gentls oscarzhou/gentls:latest
```

![](/assets/execute-result.png)

## Available ENV

If you want to add certificate for your localhsot domain, you can use the following ENVs:

```
-e CN="192.168.0.10" # your private ip address
```

If you want to add certificate for your domain, you can use the following ENVs:

```
-e CN="example.com" # your domain
```

If you want to add multiple domains, you can use the following ENVs:

```
-e CN="example.com,example2.com" # multiple domains
```
