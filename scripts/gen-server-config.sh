cat >&3 << EOF
mode server
local @@LOCAL_IP@@
lport 1195

dev-type tun
topology subnet
dev tun-roadwarrior
comp-lzo no
compress

persist-tun
persist-key

verb 2
keepalive 55 240

tls-server
remote-cert-tls client

ifconfig 100.64.0.1 255.255.255.0
ifconfig-pool 100.64.0.10 100.64.0.250

push "comp-lzo no"
push "compress"
push "route-gateway 100.64.0.1"
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
echo "<dh>" >&3
openssl dhparam 2048 >&3
echo "</dh>" >&3

echo "Server config is a template. Verify it fits your needs!"
