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

uninstall_helm_in_mac(){
    echo "Uninstalling Helm on macOS..."
    brew uninstall helm
    if [ $? -eq 0 ]; then
        echo "Helm successfully uninstalled on macOS!"
    else
        echo "Error occurred while uninstalling Helm on macOS."
    fi
}

uninstall_helm_in_linux(){
    echo "Uninstalling Helm on Ubuntu/Debian..."
    sudo apt-get remove -y helm
    sudo rm -rf /usr/share/keyrings/helm-archive-keyring.gpg
    if [ $? -eq 0 ]; then
        echo "Helm successfully uninstalled on Ubuntu/Debian!"
    else
        echo "Error occurred while uninstalling Helm on Ubuntu/Debian."
    fi
}

uninstall_helm_in_redhat(){
    echo "Uninstalling Helm on Red Hat/CentOS..."
    sudo yum remove -y helm
    sudo rm -rf /usr/share/keyrings/helm-archive-keyring.gpg
    if [ $? -eq 0 ]; then
        echo "Helm successfully uninstalled on Red Hat/CentOS!"
    else
        echo "Error occurred while uninstalling Helm on Red Hat/CentOS."
    fi
}

uninstall_helm_in_unknown(){
    echo "Manual removal required for unsupported OS."
    echo "Do you want to remove the binary file manually? (Y/N)"
    read -p "> " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Removing Helm binary..."
        sudo rm -f /usr/local/bin/helm
        if [ $? -eq 0 ]; then
            echo "Helm binary successfully removed!"
        else
            echo "Error occurred while removing Helm binary."
        fi
    else
        echo "Uninstallation canceled for unsupported OS."
    fi
}

# Main script execution
init_message
echo "Helm Uninstallation Script"

OS=$(detect_os)
echo "Detected OS: $OS"

read -p "Do you want to uninstall Helm? (Y/N): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    case "$OS" in
        "Mac")
            uninstall_helm_in_mac
            ;;
        "Linux")
            uninstall_helm_in_linux
            ;;
        "Red Hat")
            uninstall_helm_in_redhat
            ;;
        *)
            uninstall_helm_in_unknown
            ;;
    esac
else
    echo "Uninstallation canceled."
fi