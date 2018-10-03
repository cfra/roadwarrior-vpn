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
cat openvpn.key >&3
echo "</key>" >&3
