cat >&3 << EOF
client
remote $HOSTNAME 1195
remote-cert-tls server
dev tun
dev-type tun
comp-lzo no
compress
topology subnet
EOF

echo "<ca>" >&3
cat ../../pki/ca/cacert.pem >&3
echo "</ca>" >&3
echo "<cert>" >&3
cat openvpn.pem >&3
echo "</cert>" >&3
echo "<key>" >&3
cat openvpn.key >&3
echo "</key>" >&3
