Setting up a Roadwarrior VPN
============================

On some machine which you trust with the PKI:

1.  Clone this git:
    ```console
    git clone https://github.com/cfra/roadwarrior-vpn.git /etc/roadwarrior-vpn
    ```
1.  Create a `SETTINGS` file from `SETTINGS.example`.
1.  Initialize the CA:
    ```console
    ./init_ca.sh
    ```
1.  Add a client:
    ```console
    ./new client client-common-name
    ```
