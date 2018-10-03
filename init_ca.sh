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

cd "$(dirname "$0")"

if [ -d "pki/ca" ]; then
	echo "CA does already exist." >&2
	exit 1
fi

mkdir pki/ca
cd pki/ca

mkdir certs
mkdir crl
touch index.txt
mkdir newcerts
mkdir private
chmod 0700 private
echo 01 > serial
openssl genrsa \
	-aes256 \
	-out private/cakey.pem 4096
openssl req \
	-days 3650 \
	-sha256 \
	-new \
	-x509 \
	-key private/cakey.pem \
	-out cacert.pem \
	-config ../openssl-client.cnf \
	-subj "/CN=CA for $HOSTNAME"

echo "Created CA Certificate:"
openssl x509 -noout \
	-text \
	-in cacert.pem
