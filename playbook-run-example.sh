#!/bin/bash

set -e

#
# ansible-playbook -i inventory/ playbook.yml --diff --limit vpn --extra-vars='reboot=yes' --tags basic,auth,vpn --ask-become-pass
#
# --extra-vars='reboot=yes'             - reboot after applying
# --ask-become-pass                     - ask for sudo password before applying
# --extra-vars='openvpn_restart=yes'    - restart OpenVPN service
#

ansible-playbook -i inventory/ playbook.yml --diff --limit vpn
#ansible-playbook -i inventory/ playbook.yml --diff $1 $2 $3 $4 $5 $6 $7 $8 $9
