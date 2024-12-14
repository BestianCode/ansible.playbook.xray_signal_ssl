# Sample playbook for XRay VPN Server, Signal IM Proxy Server, Squid and Ngix with SSL from Let's Encrypt

## What is this?

This ansible playbook automates the setup of a server with these services:

* `Nginx` with automated provisioning of SSL certificates from `Let's Encrypt`
* `Signal IM Proxy Server` with SSL, on port `443` (xxx.my.domain:443)
* `XRay VPN Server` with SSL, on port `8443`
  * + autogenerated connection strings for users
* `Anonymous proxy` on port `63128` (xxx.my.domain:63128)
  * All trafic in the Internet works with SSL, so no worries about your data.

## Prepare your environment

* Install Ansible on your local machine:
  * Linux: `sudo apt install ansible`
  * MacOS: `brew install ansible`
  * Windows: `I don't know, sorry`

* Create VM in some Cloud Provider. Use `Debian 12` as the OS.
* Get IP address(es) of the VM. Good to have both IPv4 + IPv6 addresses for better availability from different networks.
* Create DNS name for both IPv4 + IPv6 (AAAA + A records `xxx.my.domain`). In case of using Cloudflare, dont't use proxy mode.
* Check availability of the DNS name with both IP stacks:
  * `ping xxx.my.domain`
  * `ping6 xxx.my.domain`
* Check ssh access to your new VM: `ssh root@xxx.my.domain`.
* If you use password authentication, you need to change it to key-based authentication.
  * Generate ssh key pair: `ssh-keygen`
  * Copy public key to the VM: `ssh-copy-id root@xxx.my.domain`

* Clone this repository: `git clone https://github.com/BestianCode/ansible-xray-server.git`
* Change directory: `cd ansible-xray-server`

* Edit `inventory/hosts` file and put your VM IP address(es) there, for example with hostname `vpn01`
  * `vpn01 ansible_host=xxx.my.domain ansible_user=root ansible_port=22`

* Add your ssh key to the inventory file `inventory/group_vars/all`

```yaml
manager_ssh_keys: |
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETHYQaEzZ/1ThEMdewhwkffTMBtw+hkqd4gut4Oze9l my@ed

root_ssh_keys: |
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETHYQaEzZ/1ThEMdewhwkffTMBtw+hkqd4gut4Oze9l my@ed
```

## Prepare SSL certificates provisioning

* if you use Cloudflare as a DNS provider:
  * You can add your Cloudflare API key to the inventory:
    * `inventory/group_vars/all` - For all hosts
    * OR
    * `inventory/group_vars/vpn` - Only for your VPN servers
    * OR
    * `inventory/host_vars/vpn01` - Personally for this VM host

  ```yaml
  cloudflare_token: "abcdefghijklmnopqrstuvwxyz1234567890ABCD"
  ```

  * List of available zones that you want to have SSL certificates for:

  ```yaml
  letsencrypt_domains:
  - { name: "-d *.my.domain",   email: "my.email@gmail.com", dns_provider: "cloudflare" }
  ```

* if you use another DNS provider:
  * Just add your dns name and email address to the personal VM host inventory file `inventory/host_vars/vpn01`

    ```yaml
    letsencrypt_domains:
    - { name: "-d xxx.my.domain",   email: "my.email@gmail.com", dns_provider: "" }
    ```

## Prepare VPN server configuration

* You can setup DNS name in personal VM host inventory file `inventory/host_vars/vpn01`, or by default it will be set to `ansible hostname`:
    * `xray_dns_name: "xvpn.my.domain"`

## Prepare VPN users UUIDs list

* Prepare list of VPN users with UUID and pu int the inventory:
  * `inventory/group_vars/all` - For all hosts
  * OR
  * `inventory/group_vars/vpn` - Only for your VPN servers
  * OR
  * `inventory/host_vars/vpn01` - Personally for this VM host

* UUIDs can be generated with `uuidgen` command on your local machine.

```yaml
xray_users:
  - { uid: "E6AA699D-8642-4767-8C98-DB93F958A48B", name: "John" }
  - { uid: "39ADD62B-B607-4C56-866F-364F4056EF83", name: "Vika" }
  - { uid: "A1B2C3D4-E5F6-7890-1234-56789ABCDEF0", name: "Michael" }
  - { uid: "B2C3D4E5-F678-9012-3456-789ABCDE1234", name: "Sophia" }
  - { uid: "C3D4E5F6-7890-1234-5678-9ABCDEF12345", name: "David" }
  - { uid: "D4E5F678-9012-3456-789A-BCDEF1234567", name: "Emma" }
  - { uid: "E5F67890-1234-5678-9ABC-DEF123456789", name: "James" }
  - { uid: "F6789012-3456-789A-BCDE-F123456789AB", name: "Olivia" }
  - { uid: "67890123-4567-89AB-CDEF-123456789ABC", name: "Daniel" }
  - { uid: "78901234-5678-9ABC-DEF1-23456789ABCD", name: "Ava" }
```
