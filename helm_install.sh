#!/bin/bash

helm_ascii="
                   :#+                  
                   *##:                 
      :=-          ###-         :==     
      .###-     .::*##-:.      +##+     
       :###=-+*####***####*=:.###=      
         *###*=:.       .:=####*.       
       :*#*-.               :=##+.      
       ...                     ...      
                                        
*#+   ##-  -#####=  -##      -#=     :+*
##*  .##=  -##...   -##      -###=.:*###
########=  -#####:  -##      -##+###**##
##*...##=  -##.     -##:...  -##  =: +##
##*   ##=  -#####=  -#####+  -##     +##
                                        
                                        
       -*#*:                 =*#+.      
        .*###+-.         :-*###*.       
       .*##+=*####*****####+-:###=      
      .###=    .:--*##=-:.    .*##+     
      :+=          ###-         :++     
                   *##:                 
                   :#*                  


"

init_message(){
    echo -e "\033[38;5;4m$helm_ascii\033[38;5;0m "
}

detect_os() {
    local OS=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ $ID_LIKE == *"rhel"* || $ID == "rhel" ]]; then
            OS="Red Hat"
        elif [[ $ID == "ubuntu" || $ID_LIKE == *"debian"* ]]; then
            OS="Linux"
        else
            OS="Linux"
        fi
    elif [ "$(uname)" == "Darwin" ]; then
        OS="Mac"
    else
        OS="Unknown"
    fi
    echo "$OS"
}

install_helm_in_mac(){
    echo "Installing Helm on Mac..."
    brew install helm
}

install_helm_in_linux(){
    echo "Installing Helm on Ubuntu/Debian..."
    curl -fsSL https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor -o /usr/share/keyrings/helm-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/helm-archive-keyring.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install -y helm
}

install_helm_in_redhat(){
    echo "Installing Helm on Red Hat/CentOS..."
    curl -fsSL https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor -o /usr/share/keyrings/helm-archive-keyring.gpg
    sudo yum install yum-utils -y
    sudo yum-config-manager --add-repo https://baltocdn.com/helm/stable/rpm/
    sudo yum install -y helm
}

install_helm_in_unknown(){
    echo "\nThis OS is Not Supported"
    echo "BUT, If you want to install helm through the binary file, PLEASE press 'Y' or 'y'"
    
    read -p "Do you want to install helm through the binary file? (Y/N) " answer
    
    if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
        curl -fsSL https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz -o helm.tar.gz
        tar -zxvf helm.tar.gz
        sudo mv linux-amd64/helm /usr/local/bin/helm
        echo $(helm version)
    else
        echo "Installation canceled"
    fi
    echo "\n\nInstallation is completed!"
}

init_message

echo "Helm Installation Script\n"

echo "First, Let's check the OS\n"
OS=$(detect_os)

echo "Your OS is $OS\n"

read -p "Do you want to install helm? (Y/N) " answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
    if [ "$OS" == "Linux" ]; then
        install_helm_in_linux
    elif [ "$OS" == "Red Hat" ]; then
        install_helm_in_redhat
    elif [ "$OS" == "Mac" ]; then
        install_helm_in_mac
    else
        install_helm_in_unknown
    fi
else
    echo "Invalid input. Installation canceled." 
fi