#!/bin/bash
# Author: Aravind Jarpala
# Date Created: 19/04/2024
# Description: This script is used to download all dependices for setting up local development envrionment, services include: Google Cloud SDK, JDK, AWS CLI, Kubectl, Teleport, Docker, Node, NPM
# Date Modified: 21/04/2024

# Defined Variables
DOWNLOADS_FOLDER="$HOME/Downloads"
echo "Script started running...."

usage() {
    cat << EOF
Usage:  $1 brew
        $1 teleport
        $1 jdk
        $1 aws
        $1 google-cloud-sdk
        $1 docker
        $1 node
        $1 all
EOF
}


install_homebrew() {
    local os=$1
    if [[ $os =~ [macMac]$ ]]; then
        if ! command -v brew &> /dev/null; then
            # curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "Homebrew is already installed"
        fi
    else
        echo "⚠️ Homebrew can only be installed on mac operating systems."
    fi
}

get_docker() {
    local os=$1
    if ! command -v docker &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            echo "Installing Docker using Homebrew..."
            brew install --cask docker

            echo "Starting Docker..."
            open /Applications/Docker.app
        else
            echo "Installing Docker..."
            curl -o $DOWNLOADS_FOLDER/Docker.dmg https://desktop.docker.com/mac/main/arm64/Docker.dmg

            echo "Mounting Docker Desktop DMG..."
            sudo hdiutil attach Docker.dmg

            sudo /Volumes/Docker/Docker.app/Contents/MacOS/install

            echo "Unmounting Docker Desktop DMG..."
            sudo hdiutil detach /Volumes/Docker

            read -p "Do you want to remove the downloaded file (y/N): " remove_choice
            if [[ $remove_choice =~ [yY]$ ]]; then
                rm Docker.dmg
            fi
            echo "✅ Docker installation complete."
        fi
    else  
        echo "Docker already installed"
    fi
}

get_teleport() {
    echo "Downloading teleport...."
    if ! command -v tsh &> /dev/null; then
        curl -o $DOWNLOADS_FOLDER/teleport-15.2.2.pkg https://cdn.teleport.dev/teleport-15.2.2.pkg
        
        echo "Downloaded the teleport package"
        sudo installer -pkg $DOWNLOADS_FOLDER/teleport-15.2.2.pkg -target /
        echo "✅ Teleport got installed"
    else
        echo "Teleport is already installed"
    fi

    tsh version
}

get_awscli() {
    local os=$1
    if ! command -v aws &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            echo "Downloading AWS CLI using brew....." 
            brew install awscli
        
        else
            echo "Downloading AWS CLI..."
            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

            echo "Downloaded the AWS CLI package"
            sudo installer -pkg AWSCLIV2.pkg -target /
        fi
        echo "Verifying AWS CLI installation..."
        aws --version
        echo "✅ AWS CLI installation complete."
    else
        echo "AWS is already installed."
    fi

}

get_google_cloud_sdk() {
    local os=$1
    echo "Downloading Google Cloud SDK... "
    if ! command -v gcloud &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            echo "Downloading Google Cloud SDK using brew... "
            brew install --cask google-cloud-sdk
        else
            echo "Downloading Google Cloud SDK... "
            curl -o /$DOWNLOADS_FOLDER/google-cloud-cli-472.0.0-darwin-arm.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-472.0.0-darwin-arm.tar.gz

            echo "Extracting Google Cloud SDK..."
            tar -xvf google-cloud-cli-472.0.0-darwin-arm.tar.gz

            read -p "Navigate to google-cloud-sdk directory (y/N): " choice
            if [[ $choice =~ ^[Yy]$ ]]; then
                cd $DOWNLOADS_FOLDER/google-cloud-sdk

                echo "Running installation script..."
                ./install.sh  
            else
                echo "You can manually navigate to google-cloud-sdk directory and run the installation script."
            fi
        fi

    else
        echo "Google Cloud SDK is already installed"
    fi
    read -p "Do you want to install kubectl & gke-gcloud-auth-plugin (y/N): " install_choice

    if [[ $install_choice =~ [yY]$ ]]; then
        echo "Installing Kubectl..."
        gcloud components install kubectl

        echo "Installing gke-gcloud-auth-plugin..."
        gcloud components install gke-gcloud-auth-plugin

        echo "Verifying Kubectl & gke-gcloud installation..."
        kubectl version --client
        gke-gcloud-auth-plugin --version
    else
        echo "You can manually install those using 'gcloud components install kubectl / gke-gcloud-auth-plugin.'"

    fi
    read -p "Authorize to Google Cloud SDK (y/N): " auth_choice
    if [[ $auth_choice =~ [Yy]$ ]]; then
        gcloud auth login
        echo
    else
        echo "SDK not authorized. You can manually authorize SDK later using 'gcloud auth login'."
    fi

    echo "Verifying Google Cloud SDK installation..."
    gcloud --version
}

get_jdk() {
    local os=$1
    echo "Downloading .dmg jdk file......"
    if ! command -v java &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            brew install openjdk

            echo "Verifying JDK installation..."
            java --version
        else
            curl -o /$DOWNLOADS_FOLDER/jdk-22_macos-aarch64_bin.dmg https://download.oracle.com/java/22/latest/jdk-22_macos-aarch64_bin.dmg
            echo "✅ JDK downloaded. From either the browser Downloads window or from the file browser, double-click the .dmg file to start it."
        fi
    else
        echo "JDK is already installed"
    fi
}

get_node() {
    local os=$1
    if ! command -v node &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            echo "Installing Node using brew..."
            brew install node@20
        else
            echo "Installing Node..."
            sudo apt install nodejs

            echo "Installing NPM..."
            sudo apt install npm 
        fi

        echo "Verifying the right Node.js version is in the environment"
        node -v

        echo "Verifying the right NPM version is in the environment"
        npm -v
    else
        echo "Node & Npm are already installed."
    fi

}

get_all() {
    local os=$1
    install_homebrew $os
    get_teleport
    get_jdk $os
    get_awscli $os
    get_google_cloud_sdk $os
    get_docker $os
    get_node $os
}

main() {
    local cmd=$1
    local os=$2
    case "$cmd" in
        "brew") install_homebrew "$os";;
        "teleport") get_teleport ;;
        "jdk") get_jdk $os;;
        "aws") get_awscli $os ;;
        "google-cloud-sdk") get_google_cloud_sdk $os;;
        "docker") get_docker $os;;
        "node") get_node "$os" ;;
        "all") get_all "$os";;
        *)
            usage
            exit 1
            ;;
    esac
    exit 0
}
read -p "Do you want to install dependencies on whcih OS (linux/mac):  " os_info
main "$@" "$os_info"