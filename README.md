# Setting up a Roadwarrior OpenVPN

Setting up a roadwarrior VPN with OpenVPN was a bit tricky for me. Therefore,
I have put together some scripts which should make a sensible setup easier.

Feel free to let me know if you encouter any issues with this.

## PKI

On some machine which you trust with the PKI:

1.  Clone this git:
    ```console
    git clone https://github.com/cfra/roadwarrior-vpn.git
    ```
1.  Create a `SETTINGS` file from `SETTINGS.example`.
1.  Initialize the CA:
    ```console
    ./init_ca.sh
    ```
1.  Create Server Config:
    ```console
    ./new_endpoint server <server-common-name>
    ```
1.  Create Client Config:
    ```console
    ./new_endpoint client <client-common-name>
    ```

## Server

1.  Install OpenVPN on the server:
    ```console
    apt install openvpn
    ```
1.  Edit the VPN config
1.  Put the generated config from the PKI system to the machine which should be
    the VPN server:
    ```console
    scp servers/vpn.example.com.ovpn vpn.example.com:/etc/openvpn/roadwarrior.conf
    ```
1.  On the server, enable and start the VPN service:
    ```console
    systemctl enable openvpn@roadwarrior.service
    systemctl start openvpn@roadwarrior.service
    ```
1.  Verify its status:
    ```console
    systemctl status openvpn@roadwarrior.service 
    ```

## Client

1. The generated config should just be usable as is
