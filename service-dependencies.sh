#!/bin/bash
# Author: Aravind Jarpala
# Date Created: 19/04/2024
# Description: This script is used to download all dependices for setting up local development envrionment, services include: Google Cloud SDK, JDK, AWS CLI, Kubectl, Teleport, Docker, Node, NPM
# Date Modified: 20/04/2024

# Defined Variables
DOWNLOADS_FOLDER="$HOME/Downloads"
echo "Script started running...."


install_homebrew() {
    local os= $1
    if [[ $os =~ [macMac]$ ]]; then
        if ! command -v brew &> /dev/null; then
            curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
        else
            echo "Homebrew is already installed"
        fi
    else
        echo "⚠️ Homebrew can only be installed on mac operating systems."
    fi
}

get_docker() {
    local os= $1

    if [[ $os =~ [macMac]$ ]]; then
        echo "Installing Docker using Homebrew..."
        # brew install --cask docker

        # echo "Starting Docker..."
        # open /Applications/Docker.app
    else
        if ! [ -d "/Applications/Docker.app" ]; then
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
        else 
            echo "Docker already installed"
        fi
}

get_teleport() {
    echo "Downloading teleport...."
    if ! command -v tsh &> /dev/null; then
        # curl -o $DOWNLOADS_FOLDER/teleport-15.2.2.pkg https://cdn.teleport.dev/teleport-15.2.2.pkg
        
        echo "Downloaded the teleport package"
        # sudo installer -pkg $DOWNLOADS_FOLDER/teleport-15.2.2.pkg -target /
        echo "✅ Teleport got installed"
    else
        echo "✅ Teleport is already installed"
    fi
    tsh version
}

get_awscli() {
    local os= $1
    if ! command -v aws &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            echo "Downloading AWS CLI using brew....." 
            # brew install awscli
        
        else
            echo "Downloading AWS CLI..."
            # curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

            echo "Downloaded the AWS CLI package"
            # sudo installer -pkg AWSCLIV2.pkg -target /
        fi
        echo "Verifying AWS CLI installation..."
        aws --version
        echo "✅ AWS CLI installation complete."
    else
        echo "AWS is already installed."
    fi
}

get_google_cloud_sdk() {
    local os= $1
    echo "Downloading Google Cloud SDK... "
    if [[ $os =~ [macMac]$ ]]; then
        echo "Downloading Google Cloud SDK using brew... "
        # brew install --cask google-cloud-sdk
    else
        echo "Downloading Google Cloud SDK... "
        # curl -o /$DOWNLOADS_FOLDER/google-cloud-cli-472.0.0-darwin-arm.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-472.0.0-darwin-arm.tar.gz

        echo "Extracting Google Cloud SDK..."
        # tar -xvf google-cloud-cli-472.0.0-darwin-arm.tar.gz

        read -p "Navigate to google-cloud-sdk directory (y/N): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            cd $DOWNLOADS_FOLDER/google-cloud-sdk

            echo "Running installation script..."
            # ./install.sh  
        else
            echo "You can manually navigate to google-cloud-sdk directory and run the installation script."
        fi

    echo "Installing Kubectl..."
    # gcloud components install kubectl

    echo "Installing gke-gcloud-auth-plugin..."
    # gcloud components install gke-gcloud-auth-plugin

    read -p "Authorize to Google Cloud SDK (y/N): " auth_choice

    if [[ $auth_choice =~ [Yy]$ ]]; then
        # gcloud auth login
    else
        echo "SDK not authorized. You can manually authorize SDK later using 'gcloud auth login'."
    fi

    echo "Verifying Google Cloud SDK installation..."
    gcloud --version
    kubectl version --client
    gke-gcloud-auth-plugin --version
}

get_jdk() {
    local os=$1
    echo "Downloading .dmg jdk file......"
    if [[ $os =~ [macMac]$ ]]; then
        # brew install openjdk

        echo "Verifying JDK installation..."
        java --version
    else
        # curl -o /$DOWNLOADS_FOLDER/jdk-22_macos-aarch64_bin.dmg https://download.oracle.com/java/22/latest/jdk-22_macos-aarch64_bin.dmg
        echo "✅ JDK downloaded. From either the browser Downloads window or from the file browser, double-click the .dmg file to start it."
    fi
}

get_node() {
    local os= $1
    if ! command -v node &> /dev/null; then
        if [[ $os =~ [macMac]$ ]]; then
            echo "Downloading Node using brew..."
            # brew install node@20
        # else

        fi

        echo "Verifying the right Node.js version is in the environment"
        node -v

        echo "Verifying the right NPM version is in the environment"
        npm -v
    else
        echo "Node & Npm are already installed."
    fi

}


read -p "Do you want to install dependencies on whcih OS (linux/mac):  " os_info

main() {
    install_homebrew $os_info
    get_teleport
    get_jdk $os_info
    get_google_cloud_sdk $os_info
    get_docker $os_info
    get_node $os_info
    echo "Installed all dependencies required for development environment"
}

main