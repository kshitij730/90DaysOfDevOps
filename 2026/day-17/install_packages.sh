#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

packages=("nginx" "curl" "wget")

for pkg in "${packages[@]}"
do
    if dpkg -s "$pkg" &>/dev/null
    then
        echo "$pkg is already installed."
    else
        echo "$pkg is not installed. Installing..."

        apt update -y
        apt install -y "$pkg"

        if [ $? -eq 0 ]
        then
            echo "$pkg installed successfully."
        else
            echo "Failed to install $pkg"
        fi
    fi
done
