#!/bin/bash
# =======================================================================================
# Auto Script For SSH & V2RAY & Trojan
# Auther      : Wildy Sheverando
# Created     : 27-03-2021
# Description : Welcome Script / Helping Monitoring All Service
# Port Info   : Stunnel  : 443 , 990
#               Dropbear : 110 . 143
#               OpenSSH  : 22 
#               Squid    : 8080,3128
#               HTTPS    : 1443 ( V2RAY TLS )
#               HTTP     : 80 ( V2RAY HTTP )
# SSL Cert    : V2Ray Cert By Lets Encrypt
#             : Stunnel By Default 
#             : Trojan Cert By Lets Encrypt
# Directory   : /etc/wildysheverando/
#             : /etc/trojan/
#             : /etc/v2ray/
# Source      : https://github.com/isaac-galvan/scripts-box-ftp
#             : https://www.akangerik.com/cara-membuat-vps-linux-restart-otomatis/
#             : https://github.com/NamiaKai/autoscript
#             : https://github.com/FosterG4/autoinstallopenvpn
#             : https://github.com/IDwebsource/autoinstall-openvpn-deb8
#             : https://github.com/khairilg/script-jualan-ssh-vpn
#             : https://github.com/vhandhu/auto-script-debian-7
#             : https://github.com/jhelson15/debian7_32bit
#             : https://github.com/dicecat/bwh-auto
#             : https://github.com/veekxt/v2ray-template/blob/master/tcp%2Bvmess%20and%20balance/config.json
#             : https://github.com/veekxt/v2ray-template/blob/master/quic%2Bvmess/config.json
#             : https://www.v2ray.com/en/configuration/protocols/vmess.html
#             : https://v2ray.cool/en/welcome/install.html
#             : https://github.com/trojan-gfw/trojan-quickstart
#             : https://openrepos.net/content/forthefreedom/jolla-settings-v2ray
# Thanks To   : Horas Siregar Amsal / t.me/@horasss
#             : The Hoster / Fastssh
#             : Joy / Fastssh 
#             : My Friend
#             : Google
#             : Github Repository
# Os Info     : Supported Only For Debian 8 , Debian 9 , Debian 10
#             : Ubuntu 16.04 , Ubuntu 18.04 , Ubuntu 20.04 , Ubuntu 20.10 ( V2Ray Eror )
#             : Centos Not Supported
#             : FreeBSD Not Supported
#             : Fedora Not Supported
#             : Kali Linux Supported ( Kali 2019 - 2020 )
# Backup      : FTP 
#             : Using FTP Keys
#             : Linux FTP Tools
# =======================================================================================

# IP Validation
MYAIPIADDRESS=$(wget -qO- ipv4.icanhazip.com);

# VPS Information
Checkstart1=$(ip route | grep default | cut -d ' ' -f 3 | head -n 1);
if [[ $Checkstart1 == "venet0" ]]; then 
    clear
	  lan_net="venet0"
    typevps="OpenVZ"
    sleep 1
else
    clear
		lan_net="eth0"
    typevps="KVM"
    sleep 1
fi

# Getting OS Information
source /etc/os-release
Versi_OS=$VERSION
ver=$VERSION_ID
Tipe=$NAME
URL_SUPPORT=$HOME_URL
basedong=$ID

# VPS ISP INFORMATION
ITAM='\033[0;30m'
echo -e "$ITAM"
NAMAISP=$( curl ipinfo.io/org | cut -d " " -f 2-10  )
clear
REGION=$( curl -q ipinfo.io/region )
clear
COUNTRY=$( curl -q ipinfo.io/country )
clear
WAKTU=$( curl -q ipinfo.ip/timezone )
clear
CITY=$( curl -q ipinfo.io/city )
clear
REGION=$( curl -q ipinfo.io/region )
clear
WAKTUE=$( curl -q ipinfo.io/timezone )
clear
koordinat=$( curl -q ipinfo.io/loc )
clear
NC='\033[0m'
echo -e "$NC"

# Check Status
tls_v2ray_status=$(systemctl status v2ray@tls-server | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nontls_v2ray_status=$(systemctl status v2ray@nontls-server | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trojan_server=$(systemctl status trojan-server | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
stunnel_service=$(/etc/init.d/stunnel4 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
squid_service=$(/etc/init.d/squid status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# Color Validation
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
clear

# Status Service  SSH 
if [[ $ssh_service == "running" ]]; then 
   status_ssh="${GREEN}SSH/Tunnel Service Is Running ${NC}( No Eror )"
else
   status_ssh="${RED}SSH/Tunnel Service Is Not Running ${NC}( Eror )"
fi

# Status Service  Squid 
if [[ $squid_service == "running" ]]; then 
   status_squid="${GREEN}Squid Service Is Running ${NC}( No Eror )"
else
   status_squid="${RED}Squid Service Is Not Running ${NC}( Eror )"
fi

# Status Service  VNSTAT 
if [[ $vnstat_service == "running" ]]; then 
   status_vnstat="${GREEN}Vnstat Service Is Running ${NC}( No Eror )"
else
   status_vnstat="${RED}Vnstat Service Is Not Running ${NC}( Eror )"
fi

# Status Service  Crons 
if [[ $cron_service == "running" ]]; then 
   status_cron="${GREEN}Crons Service Is Running ${NC}( No Eror )"
else
   status_cron="${RED}Crons Service Is Not Running ${NC}( Eror )"
fi

# Status Service  Fail2ban 
if [[ $fail2ban_service == "running" ]]; then 
   status_fail2ban="${GREEN}Fail2Ban Service Is Running ${NC}( No Eror )"
else
   status_fail2ban="${RED}Fail2Ban Service Is Not Running ${NC}( Eror )"
fi

# Status Service  TLS 
if [[ $tls_v2ray_status == "running" ]]; then 
   status_tls_v2ray="${GREEN}V2Ray TLS Service Is Running${NC} ( No Eror )"
else
   status_tls_v2ray="${RED}V2Ray TLS Service Is Not Running${NC} ( Eror )"
fi

# Status Service Non TLS V2Ray
if [[ $nontls_v2ray_status == "running" ]]; then 
   status_nontls_v2ray="${GREEN}V2Ray HTTP Service Is Running ${NC}( No Eror )${NC}"
else
   status_nontls_v2ray="${RED}V2Ray HTTP Service Is Not Running ${NC}( Eror )${NC}"
fi

# Status Service Trojan
if [[ $trojan_server == "running" ]]; then 
   status_virus_trojan="${GREEN}Trojan Service Is Running ${NC}( No Eror )${NC}"
else
   status_virus_trojan="${RED}Trojan Service Is Not Running ${NC}( Eror )${NC}"
fi

# Status Service Dropbear
if [[ $dropbear_status == "running" ]]; then 
   status_beruangjatuh="${GREEN}Dropbear Service Is Running${NC} ( No Eror )${NC}"
else
   status_beruangjatuh="${RED}Dropbear Service Is Not Running ${NC}( Eror )${NC}"
fi

# Status Service Stunnel
if [[ $stunnel_service == "running" ]]; then 
   status_stunnel="${GREEN}Stunnel Service Is Running ${NC}( No Eror )"
else
   status_stunnel="${RED}Stunnel Service Is Not Running ${NC}( Eror )}"
fi

# Ram Usage
total_r2am=` grep "MemAvailable: " /proc/meminfo | awk '{ print $2}'`
MEMORY=$(($total_r2am/1024))

# Download
download=`grep -e "lo:" -e "wlan0:" -e "eth0" /proc/net/dev | awk '{print $10}' | paste -sd+ - | bc`
downloadsize=$(($download/1073741824))

# Upload
upload=`grep -e "lo:" -e "wlan0:" -e "eth0" /proc/net/dev | awk '{print $10}' | paste -sd+ - | bc`
uploadsize=$(($upload/1073741824))

# Total Ram
total_ram=` grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))

# Tipe Processor
totalcore="$(grep -c "^processor" /proc/cpuinfo)" 
totalcore+=" Core"
corediilik="$(grep -c "^processor" /proc/cpuinfo)" 
tipeprosesor="$(awk -F ': | @' '/model name|Processor|^cpu model|chip type|^cpu type/ {
                        printf $2;
                        exit
                        }' /proc/cpuinfo)"

# Shell Version
shellversion=""
shellversion=Bash
shellversion+=" Version" 
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion

# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"

# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

# Disk Information
disk="`df -h | grep "/$" | awk '{print $2 " "$3 " " $4 " " $5}'`"
echo "Informasi $disk" > /etc/wildysheverando/storage_size.txt
totalsize=$(grep "^Informasi " "/etc/wildysheverando/storage_size.txt" | cut -d " " -f 2 )
usage=$(grep "^Informasi " "/etc/wildysheverando/storage_size.txt" | cut -d " " -f 3 )
tersedia=$(grep "^Informasi " "/etc/wildysheverando/storage_size.txt" | cut -d " " -f 4 )
jumlahyangdipakai=$(grep "^Informasi " "/etc/wildysheverando/storage_size.txt" | cut -d " " -f 5 )

# Getting GPU Vendor 
gpu_cmd="$(lspci -mm | awk -F '\\"|\\" \\"|\\(' \
             '/"Display|"3D|"VGA/ {a[$0] = $3 " " $4} END {for(i in a)
             {if(!seen[a[i]]++) print a[i]}}')"
IFS=$'\n' read -d "" -ra gpus <<< "$gpu_cmd"

[[ "${gpus[0]}" == *Intel* && \
"${gpus[1]}" == *Intel* ]] && \
unset -v "gpus[0]"

for gpu in "${gpus[@]}"; do
    [[ "$gpu_type" == "dedicated" && "$gpu" == *Intel* ]] || \
    [[ "$gpu_type" == "integrated" && ! "$gpu" == *Intel* ]] && \
    { unset -v gpu; continue; }

    case "$gpu" in
    *"advanced"*)
    brand="${gpu/*AMD*ATI*/AMD ATI}"
    brand="${brand:-${gpu/*AMD*/AMD}}"
    brand="${brand:-${gpu/*ATI*/ATi}}"
    gpu="${gpu/\[AMD\/ATI\] }"
    gpu="${gpu/\[AMD\] }"
    gpu="${gpu/OEM }"
    gpu="${gpu/Advanced Micro Devices, Inc.}"
    gpu="${gpu/*\[}"
    gpu="${gpu/\]*}"
    gpu="$brand $gpu"
    ;;

    *"nvidia"*)
    gpu="${gpu/*\[}"
    gpu="${gpu/\]*}"
    gpu="NVIDIA $gpu"
    ;;

    *"intel"*)
    gpu="${gpu/*Intel/Intel}"
    gpu="${gpu/\(R\)}"
    gpu="${gpu/Corporation}"
    gpu="${gpu/ \(*}"
    gpu="${gpu/Integrated Graphics Controller}"
    gpu="${gpu/*Xeon*/Intel HD Graphics}"
    [[ -z "$(trim "$gpu")" ]] && gpu="Intel Integrated Graphics"
    ;;

    *"virtualbox"*)
    gpu="VirtualBox Graphics Adapter"
    ;;
    esac

        if [[ "$gpu_brand" == "off" ]]; then
                gpu="${gpu/AMD }"
                gpu="${gpu/NVIDIA }"
                gpu="${gpu/Intel }"
        fi
    done

# Kernel Terbaru
kernelku=$(uname -r)

# Waktu Sekarang 
harini=`date -d "0 days" +"%d-%m-%Y"`
jam=`date -d "0 days" +"%X"`

# DNS Patch
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
tipeos2=$(uname -m)

# Getting Domain Name
source /etc/wildysheverando/domain-untuk-v2ray
Domen=$Domain

# Echoing Result
echo -e "
${RED} _  _  _  _  _      _           ______                   _                     
${CYAN}| || || |(_)| |    | |         (_____ \                 (_)               _    
${GREEN}| || || | _ | |  _ | | _   _    _____) )  ____   ___     _   ____   ____ | |_  
${PURPLE}| ||_|| || || | / || || | | |  |  ____/  / ___) / _ \   | | / _  ) / ___)|  _) 
${BLUE}| |___| || || |( (_| || |_| |  | |      | |    | |_| |  | |( (/ / ( (___ | |__ 
${ORANGE} \______||_||_| \____| \__  |  |_|      |_|     \___/  _| | \____) \____) \___)
${PURPLE}                      (____/                          (__/                     
${NC}
             THIS SCRIPT IS FREE FOR PERSONAL USE ( NOT FOR SALE )
               IF YOU BUY THIS SCRIPT FROM ANY PEOPLE PLEASE SAY
                         TO REFUND ( THIS IS FOR FREE )
                    © Copyright 2021 By ${GREEN}Wildy Sheverando${NC}
"
echo -e "Halo , $HOSTNAME Welcome To Server "
echo "-------------------------------------------------------------------------------"
echo "Operating System Information :"
echo -e "VPS Type   : $typevps"
echo -e "OS Arch    : $tipeos2"
echo -e "Hostname   : $HOSTNAME"
echo -e "OS Name    : $Tipe"
echo -e "OS Version : $Versi_OS"
echo -e "OS URL     : $URL_SUPPORT"
echo -e "OS BASE    : $basedong"
echo -e "OS TYPE    : Linux / Unix"
echo -e "Bash Ver   : $versibash"
echo -e "Kernel Ver : $kernelku"
echo "-------------------------------------------------------------------------------"
echo "Hardware Information :"
echo -e "Processor  : $tipeprosesor"
echo -e "Proc Core  : $totalcore"
echo -e "GPU Vendor : ${subtitle:+${subtitle}${gpu_name}}""$gpu"
echo -e "Virtual    : $typevps"
echo -e "Cpu Usage  : $cpu_usage"
echo "-------------------------------------------------------------------------------"
echo "System Status / System Information :"
echo -e "Uptime     : $uptime ( From VPS Booting )"
echo -e "Rom        : $totalsize"
echo -e "Rom Usage  : ${usage}B / $jumlahyangdipakai"
echo -e "Avaible    : ${tersedia}B"
echo -e "Total RAM  : ${totalram}MB"
echo -e "Avaible    : ${MEMORY}MB"
echo -e "Download   : $downloadsize GB ( From Startup / VPS Booting )"
echo -e "Upload     : $uploadsize GB ( From Startup / VPS Booting )"
echo "-------------------------------------------------------------------------------"
echo "Internet Service Provider Information :"
echo -e "Public IP  : $MYAIPIADDRESS"
echo -e "Domain     : $Domen"
echo -e "DNS Server : $nameservers"
echo -e "ISP Name   : $NAMAISP"
echo -e "Region     : $REGION "
echo -e "Country    : $COUNTRY"
echo -e "City       : $CITY "
echo -e "Time Zone  : $WAKTUE"
echo "-------------------------------------------------------------------------------"
echo "Time & Date & Location & Coordinate Information :"
echo -e "Location   : $COUNTRY"
echo -e "Coordinate : $koordinat"
echo -e "Time Zone  : $WAKTUE"
echo -e "Date       : $harini"
echo -e "Time       : $jam ( WIB )"
echo -e "Coordinate : $koordinat"
echo "-------------------------------------------------------------------------------"
echo "System Status Information :"
echo -e "SSH / Tun  : $status_ssh"
echo -e "Dropbear   : $status_beruangjatuh"
echo -e "Stunnel    : $status_stunnel"
echo -e "Squid      : $status_squid"
echo -e "Fail2Ban   : $status_fail2ban"
echo -e "Crons      : $status_cron"
echo -e "Vnstat     : $status_vnstat"
echo -e "V2Ray HTTP : $status_nontls_v2ray"
echo -e "V2Ray TLS  : $status_tls_v2ray"
echo -e "Trojan     : $status_virus_trojan"
echo "-------------------------------------------------------------------------------
"
echo ""