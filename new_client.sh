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

. ./SETTINGS

if [ $# -ne 1 ]; then
	echo "This script creates new credentials for a VPN client." >&2
	echo "Usage: $0 <common_name>" >&2
	exit 1
fi

cd "$(dirname "$0")"
mkdir -p clients

CLIENT_DIR="clients/$1"
if [ -d "$CLIENT_DIR" ]; then
	echo "There is already a config for this client." >&2
	exit 1
fi

mkdir "$CLIENT_DIR"
cd "$CLIENT_DIR"

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
	-config ../../pki/openssl.cnf \
	-subj "/CN=$1"

cd ../../pki
openssl ca \
	-config ../pki/openssl.cnf \
	-out "../$CLIENT_DIR/openvpn.pem.txt" \
	-in "../$CLIENT_DIR/openvpn.req"

cd "../$CLIENT_DIR"
openssl x509 \
	-in openvpn.pem.txt \
	-out openvpn.pem

exec 3>"../$1.ovpn"
cat >&3 << EOF
client
remote $HOSTNAME 1195
remote-crt-tls server
dev-type tun
EOF

echo "<ca>" >&3
cat ../../pki/ca/cacert.pem >&3
echo "</ca>" >&3
echo "<cert>" >&3
cat openvpn.pem >&3
echo "</cert>" >&3
echo "<key>" >&3
cat openvpn.pem >&3
echo "</key>" >&3

exec 3>&-
echo "Client config created."
