#!/bin/bash

# This script will install the ovpn files and add the zsh function to your .zshrc file

# make the directory for the ovpn files
mkdir -p ~/.local/ovpn

# download the script to the folder
wget -P ~/.local/ovpn https://raw.githubusercontent.com/parsanoori/ovpn/main/ovpn_redirect.sh

# make the script executable
chmod +x ~/.local/ovpn/ovpn_redirect.sh

# make the pass.txt file
touch ~/.local/ovpn/pass.txt

# get user input for the username and password
read -p "Enter your username: " username
read -p "Enter your password: " password

# write the username and password to the pass.txt file
echo "$username" > ~/.local/ovpn/pass.txt
echo "$password" >> ~/.local/ovpn/pass.txt

# get the usual proxy address and port
read -p "Enter your usual proxy address: " proxy_address
read -p "Enter your usual proxy port: " proxy_port

# add the zsh function to the .zshrc file
echo "function ovpn {"                                                          >> ~/.zshrc
echo "    if [ -z \"\$1\" ]; then"                                              >> ~/.zshrc
echo "        echo \"Usage: ovpn <config> [socks proxy] [socks port]\""         >> ~/.zshrc
echo "        return 1"                                                         >> ~/.zshrc
echo "    fi"                                                                   >> ~/.zshrc
echo ""                                                                         >> ~/.zshrc
echo "    if [ -z \"\$2\" ]; then"                                              >> ~/.zshrc
echo "        sudo openvpn \\"                                                  >> ~/.zshrc
echo "            --config \$1 \\"                                              >> ~/.zshrc
echo "            --socks-proxy $proxy_address $proxy_port \\"                  >> ~/.zshrc
echo "            --auth-user-pass ~/.local/ovpn/pass.txt \\"                   >> ~/.zshrc
echo "            --up ~/.local/ovpn/ovpn_redirect.sh \\"                       >> ~/.zshrc
echo "            --down ~/.local/ovpn/ovpn_redirect.sh \\"                     >> ~/.zshrc
echo "            --route-noexec --script-security 3"                           >> ~/.zshrc
echo "    else"                                                                 >> ~/.zshrc
echo "        sudo openvpn \\"                                                  >> ~/.zshrc
echo "            --config \$1 \\"                                              >> ~/.zshrc
echo "            --socks-proxy \$2 \$3 \\"                                     >> ~/.zshrc
echo "            --auth-user-pass ~/.local/ovpn/pass.txt \\"                   >> ~/.zshrc
echo "            --up ~/.local/ovpn/ovpn_redirect.sh \\"                       >> ~/.zshrc
echo "            --down ~/.local/ovpn/ovpn_redirect.sh \\"                     >> ~/.zshrc
echo "            --route-noexec --script-security 3"                           >> ~/.zshrc
echo "    fi"                                                                   >> ~/.zshrc
echo "}"                                                                        >> ~/.zshrc

# source the .zshrc file
source ~/.zshrc

# ask the user to download the config files
echo "Download the ProtonVPN's config files and extract them any where you want"

# guide the user
echo "Use the ovpn command followed by the config file name to connect to the VPN"

