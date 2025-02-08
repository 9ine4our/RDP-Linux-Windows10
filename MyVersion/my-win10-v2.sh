#!/bin/bash

stty intr ""
stty quit ""
stty susp undef

clear
rm -rf ngrok ngrok.zip ng.sh > /dev/null 2>&1
echo "======================="
echo "Downloading ngrok script..."
echo "======================="
wget -O ng.sh https://raw.githubusercontent.com/9ine4our/RDP-Linux-Windows10/main/MyVersion/myngrok.sh > /dev/null 2>&1
chmod +x ng.sh
./ng.sh

function restart_ngrok {
    clear
    echo "Ngrok Error! Please try again!"
    sleep 1
    start_ngrok
}

function start_ngrok {
    clear
    echo "Go to https://dashboard.ngrok.com/get-started/your-authtoken"
    read -p "Paste Ngrok Authtoken: " AUTH_TOKEN
    ./ngrok config add-authtoken $AUTH_TOKEN
    
    clear
    echo "Repo: windows10"
    echo "======================="
    echo "Choose ngrok region (for better connection)."
    echo "======================="
    echo "us - United States (Ohio)"
    echo "eu - Europe (Frankfurt)"
    echo "ap - Asia/Pacific (Singapore)"
    echo "au - Australia (Sydney)"
    echo "sa - South America (Sao Paulo)"
    echo "jp - Japan (Tokyo)"
    echo "in - India (Mumbai)"
    read -p "Choose ngrok region: " REGION

    ./ngrok tcp --region $REGION 4000 &>/dev/null &
    sleep 3

    if curl --silent --show-error http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then
        echo "Ngrok is running successfully!"
    else
        restart_ngrok
    fi
}

start_ngrok

docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=user --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:windows10

clear
echo "NoMachine: https://www.nomachine.com/download"
echo "Done! NoMachine Information:"
echo "IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "User: user"
echo "Passwd: 123456"
echo "VM can't connect? Restart Cloud Shell then Re-run script."

while true; do
    for s in "Running .    " "Running ..   " "Running ...  " "Running .... "; do
        echo -en "\r$s"
        sleep 0.5
    done
done
