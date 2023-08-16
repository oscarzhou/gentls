#!/bin/sh

mode="$1"

OS=$(uname -s)
ARCH=$(uname -m)

# Set the certificate details
if [ "$mode" = "debug" ]; then
  echo "Running in Debug Mode"
  # Debug mode specific commands or actions

    CERT_DIR="./certificates"
else
  echo "Running in Production Mode"
  # Production mode specific commands or actions
    CERT_DIR="/data"
fi

# Set the CN names for the server and client certificates
CN="${CN:-127.0.0.1,localhost}"

echo "CN: ${CN}"
echo "arch: ${ARCH}"
echo "platform: ${OS}"

# Set binary path
cfssl="$(pwd)/bin/cfssl_1.6.4_linux_arm64" 
cfssljson="$(pwd)/bin/cfssljson_1.6.4_linux_arm64" 

if [ "$ARCH" = "x86_64" ]; then 

  cfssl="$(pwd)/bin/cfssl_1.6.4_linux_amd64"
  cfssljson="$(pwd)/bin/cfssljson_1.6.4_linux_amd64"

fi

# Create the directory for certificates
mkdir -p "${CERT_DIR}"

# Generate the CA's private key and certificate
"$cfssl" print-defaults csr | "$cfssl" gencert -initca - | "$cfssljson" -bare "${CERT_DIR}/ca"

echo '{
  "signing": {
    "default": {
      "expiry": "87600h",
      "usages": ["signing", "key encipherment", "server auth", "client auth"]
    }
  }
}' > cfssl.json

echo '{}' | "$cfssl" gencert -ca="${CERT_DIR}/ca.pem" -ca-key="${CERT_DIR}/ca-key.pem" -config="cfssl.json" \
    -hostname="${CN}" - | "$cfssljson" -bare "${CERT_DIR}/server"

echo '{}' | "$cfssl" gencert -ca="${CERT_DIR}/ca.pem" -ca-key="${CERT_DIR}/ca-key.pem" -config="cfssl.json" \
    -hostname="${CN}" - | "$cfssljson" -bare "${CERT_DIR}/client"

chmod 644 "${CERT_DIR}/ca.pem" "${CERT_DIR}/server.pem" "${CERT_DIR}/client.pem" "${CERT_DIR}/server-key.pem" "${CERT_DIR}/client-key.pem" "${CERT_DIR}/ca.pem"