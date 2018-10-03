#!/bin/sh

# Based on a template by BASH3 Boilerplate v2.3.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CLIENT_DIR="${BASE_DIR}/clients"
SERVER_DIR="${BASE_DIR}/servers"

. "${BASE_DIR}/SETTINGS"

if [ $# -ne 2 ]; then
	echo "This script creates new credentials for a VPN endpoint." >&2
	echo "Usage: $0 <client|server> <common_name>" >&2
	exit 1
fi

ENDPOINT_TYPE="$1"
ENDPOINT="$2"

if [ x"$ENDPOINT_TYPE" = x"client" ]; then
	ENDPOINT_DIR="${CLIENT_DIR}/${ENDPOINT}"
	OPENSSL_CONFIG="${BASE_DIR}/pki/openssl.cnf"
elif [ x"$ENDPOINT_TYPE" = x"server" ]; then
	ENDPOINT_DIR="${SERVER_DIR}/${ENDPOINT}"
	OPENSSL_CONFIG="${BASE_DIR}/pki/openssl-server.cnf"
else
	echo "Endpoint type should be 'client' or 'server'!" >&2
	exit 1
fi

if [ -d "$ENDPOINT_DIR" ]; then
	echo "There is already a config for this endpoint." >&2
	exit 1
fi

mkdir -p "$CLIENT_DIR"
mkdir -p "$SERVER_DIR"

mkdir "$ENDPOINT_DIR"
cd "$ENDPOINT_DIR"

openssl genpkey \
	-out openvpn.key \
	-outform PEM \
	-algorithm RSA \
	-pkeyopt rsa_keygen_bits:4096
openssl req \
	-sha256 \
	-new \
	-key openvpn.key \
	-out openvpn.req \
	-config "${OPENSSL_CONFIG}" \
	-subj "/CN=${ENDPOINT}"

cd "${BASE_DIR}/pki"
openssl ca \
	-config "${OPENSSL_CONFIG}" \
	-out "${ENDPOINT_DIR}/openvpn.pem.txt" \
	-in "${ENDPOINT_DIR}/openvpn.req"

cd "$ENDPOINT_DIR"
openssl x509 \
	-in openvpn.pem.txt \
	-out openvpn.pem

exec 3>"${ENDPOINT_DIR}.ovpn"

. "${BASE_DIR}/scripts/gen-${ENDPOINT_TYPE}-config.sh"

exec 3>&-
echo "Config created."
