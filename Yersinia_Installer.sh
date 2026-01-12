#!/bin/bash

red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
cyan="\e[36m"
magenta="\e[35m"
endcolor="\e[0m"


progress_bar() {
    local duration=$1
    local bar_length=50
    local elapsed=0

    echo -ne "["

    while [ $elapsed -lt $duration ]; do
        sleep 1
        elapsed=$((elapsed + 1))
        percent=$((elapsed * 100 / duration))
        filled_bar=$((percent * bar_length / 100))

        echo -ne "\r["
        for ((i = 0; i < filled_bar; i++)); do
            echo -ne "="
        done
        for ((i = filled_bar; i < bar_length; i++)); do
            echo -ne " "
        done
        echo -ne "] $percent%"
    done

    echo -ne "\r["
    for ((i = 0; i < bar_length; i++)); do
        echo -ne "="
    done
    echo "] 100%"
}

privileges(){
    if [[ $(id -u) -ne 0 ]]; then
        echo -e "${red}[!] WARNING!!! \nThis script must run with root privileges \nPlease restart the script under root \nTerminating script operations...${endcolor}"

        exit 1
    fi

    printf "$yellow"
    figlet -f small "Yersinia Installer"
    printf "$endcolor"

}




installation(){
read -p "$(echo -e "${cyan}\xE2\x98\x90${endcolor}${yellow} Please provide a folder path for Yersinia cloning: ${endcolor}")" yerpath
sleep 0.2 
if [ ! -z $yerpath ]
    then
    echo -e "${cyan}\xE2\x98\x91${endcolor}${green} Yersinia will be cloned into ${endcolor}${magenta}$yerpath${endcolor}" ; sleep 0.3
    echo -e "${cyan}\xE2\x98\x90${endcolor}${blue} Cloning...${endcolor}"
    git clone https://github.com/tomac/yersinia $yerpath &>/dev/null
    progress_bar 10
    echo -e "${cyan}\xE2\x98\x91${endcolor}${green} Cloning complete${endcolor}"  ; sleep 0.3
    echo -e "${cyan}\xE2\x98\x90${endcolor}${blue} Installing dependencies...${endcolor}"
    apt install autoconf libgtk-3-dev libnet1-dev libgtk2.0-dev libpcap-dev -y &>/dev/null
    progress_bar 20
    echo -e "${cyan}\xE2\x98\x91${endcolor}${green} Dependency installation complete${endcolor}" ; sleep 0.3
    echo -e "${cyan}\xE2\x98\x90${endcolor}${blue} Configuring and installing Yersinia...${endcolor}"
    cd $yerpath
    ./autogen.sh &>/dev/null
    make &>/dev/null
    make install &>/dev/null
    progress_bar 30
    if ! command -v yersinia &>/dev/null
	then
	echo -e "${red}\xE2\x9A\xA0 Yersinia installation failed${endcolor}"
	else
    	echo -e "\n${green}\xE2\x98\x91 Yersinia installation complete${endcolor}"
    fi
    else
    echo -e "${red}\xE2\x9A\xA0 No path was specified${endcolor}"
    sleep 0.5 ; installation
fi

}

privileges
installation
