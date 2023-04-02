#!/usr/bin/env bash

ArvanIPsLink="https://www.arvancloud.ir/fa/ips.txt"
IranIPsLink="https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/ir.cidr"
ArvanIPsFile="/tmp/ar-ips.txt"
IranIPsFile="/tmp/ir-ips.txt"
IPsFile="/tmp/ips.txt"
NGWFile="/tmp/ngw.txt"

downloadfile() {
    if [[ -x "$(command -v curl)" ]]; then
        downloadStatus=$(curl "$1" -o "$2" -L -s -w "%{http_code}\n")
    elif [[ -x "$(command -v wget)" ]]; then
        downloadStatus=$(wget "$1" -O "$2" --server-response 2>&1 | awk '/^  HTTP/{print $2}' | tail -n1)
    else
        echo "curl or wget is required to run this script."
        exit 1
    fi
}


if [ "$script_type" == "up" ]; then
  echo "========================I start here========================"

  #echo "Downloading Arvancloud IPs list..."
  #downloadfile "$ArvanIPsLink" "$ArvanIPsFile"
  #if [ $downloadStatus -ne 200 ]; then
  #  echo "Failed to download Arvancloud IPs list."
  #  exit 1
  #else
  #  echo "Downloaded IPs"
  #fi
  #echo "Downloaded Arvancloud IPs"

  echo "Downloading Iran IPs list..."
  downloadfile "$IranIPsLink" "$IranIPsFile"
  if [ $downloadStatus -ne 200 ]; then
    echo "Failed to download Iran IPs list."
    touch "$IranIPsFile"
  else
    echo "Downloaded IPs"
  fi
  echo "Downloaded Iran IPs"

  echo "Merging IPs..."
  echo -e "$(cat $IranIPsFile)\n$(dig +short arvan.nparsa.ir)" > $IPsFile
  echo "Merged IPs"

  IPs=$(cat "$IPsFile")

  echo "Putting route gateway in $NGWFile"
  echo "$route_net_gateway" > "$NGWFile"
  echo "Put route gateway in $NGWFile"

  /sbin/route delete default
  /sbin/route add default $route_vpn_gateway
  /sbin/route add -net 128.0.0.0/1 $route_vpn_gateway
  for IP in ${IPs}; do
    /sbin/route add -net "${IP}" $route_net_gateway > /dev/null
  done
  echo "========================I end here========================"
  
elif [ "$script_type" == "down" ]; then
  echo "========================I start here========================"
  IPs=$(cat "$IPsFile")
  route_net_gateway=$(cat "$NGWFile")
  echo "/sbin/route add default $route_net_gateway"
  /sbin/route add default $route_net_gateway
  for IP in ${IPs}; do
    /sbin/route delete -net "${IP}" > /dev/null
  done
  echo "========================I end here========================"
fi
