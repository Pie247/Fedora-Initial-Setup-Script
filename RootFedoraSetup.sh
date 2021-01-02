#!/bin/bash

passwd -l root #lock root password

#user prompts

computerType=4
until [ $computerType == 1 ] || [ $computerType == 2 ]
do
    read -p "Enter 1 if this is a laptop or 2 if this is a desktop: " computerType
done

nvidia='a'
until [ $nvidia == 'y' ] || [ $nvidia == 'Y' ] || [ $nvidia == 'n' ] || [ $nvidia == 'N' ]
do
    read -p "Install Nvidia graphics drivers [y\N]: " nvidia 
done

username='a'
sureUsername='N'
until [ $sureUsername == 'y' ] || [ $sureUsername == 'Y' ]
do
    read -p "Enter your username: " username
    read -p "Are you sure? [y\N]: " sureUsername
done

homeDir="/home/$username"


#repo prompts
nonfree='a'
until [ $nonfree == 'y' ] || [ $nonfree == 'Y' ] || [ $nonfree == 'n' ] || [ $nonfree == 'N' ]
do
    read -p "Install non-free software? [y\N]: " nonfree
done

#programming language prompts
languages='a'
until [ $languages == 'y' ] || [ $languages == 'Y' ] || [ $languages == 'n' ] || [ $languages == 'N' ]
do
    read -p "Install all available programming languages? [y\N]: " languages
done

if [ $languages == 'y' ] || [ $languages == 'Y' ]
then
    rust='y'
    openjdk='y'
    dotnet='y'
    golang='y'
    ruby='y'
    powershell='y'
else
    rust='a'
    until [ $rust == 'y' ] || [ $rust == 'Y' ] || [ $rust == 'n' ] || [ $rust == 'N' ]
    do
        read -p "Install Rust? [y/N]: " rust
    done
    
    openjdk='a'
    until [ $openjdk == 'y' ] || [ $openjdk == 'Y' ] || [ $openjdk == 'n' ] || [ $openjdk == 'N' ]
    do
        read -p "Install OpenJDK? [y/N]: " openjdk
    done
    
    dotnet='a'
    until [ $dotnet == 'y' ] || [ $dotnet == 'Y' ] || [ $dotnet == 'n' ] || [ $dotnet == 'N' ]
    do
        read -p "Install .NET Core SDK? [y/N]: " dotnet
    done
    
    golang='a'
    until [ $golang == 'y' ] || [ $golang == 'Y' ] || [ $golang == 'n' ] || [ $golang == 'N' ]
    do
        read -p "Install Golang? [y/N]: " golang
    done
    
    ruby='a'
    until [ $ruby == 'y' ] || [ $ruby == 'Y' ] || [ $ruby == 'n' ] || [ $ruby == 'N' ]
    do
        read -p "Install Ruby? [y/N]: " ruby
    done
    
    powershell='a'
    until [ $powershell == 'y' ] || [ $powershell == 'Y' ] || [ $powershell == 'n' ] || [ $powershell == 'N' ]
    do
        read -p "Install PowerShell? [y/N]: " powershell
    done
    
fi

#development tool prompts
if [ $nonfree == 'y' ] || [ $nonfree == "Y"]
then
    vscode='a'
    until [ $vscode == 1 ] || [ $vscode == 2 ]
    do
        read -p "Install VSCode or VSCodium? [1/2]: " vscode
    done
else
    vscode=2
fi



dnf upgrade -y



#remove unneeded programs
dnf remove -y totem totem-plugins #gnome videos
dnf remove -y cheese


#add repos

#RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

if [ $nonfree == 'y' ] || [ $nonfree == 'Y' ]
then
    dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

#Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if [ $vscode == 1 ]
then
    #VSCode
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    microsoftKey=1
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
else
    #VSCodium
    sudo rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
    printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" | sudo tee -a /etc/yum.repos.d/vscodium.repo
fi

#OpenJDK
if [ $openjdk == 'y' ] || [ $openjdk == 'Y' ]
then
    #AdoptOpenJDK for LTS
    wget -O /etc/yum.repos.d/adoptopenjdk.repo https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/openjdk/adoptopenjdk.repo
fi


#.NET Core SDK
if [ $dotnet == 'y' ] || [ $dotnet == 'Y' ]
then
    if [ $microsoftKey != 1 ]
    then
        rpm --import https://packages.microsoft.com/keys/microsoft.asc
        $microsoftKey=1
    fi
    wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/$(rpm -E %fedora)/prod.repo
fi



#install software

#install drivers

if [ $nvidia == 'y' ] || [ $nvidia == 'Y' ]
then
dnf install akmod-nvidia
fi

#install programming languages
if [ $openjdk == 'y' ] || [ $openjdk == 'Y' ]
then
    dnf install -y java-latest-openjdk-devel
fi

if [ $dotnet == 'y' ] || [ $dotnet == 'Y' ]
then
    dnf install -y dotnet-sdk
fi

if [ $golang == 'y' ] || [ $golang == 'Y' ]
then
    dnf install -y golang
fi

if [ $ruby == 'y' ] || [ $ruby == 'Y' ]
then
    dnf install -y ruby-devel
fi




#install development tools
dnf install -y @development-tools
dnf install -y vim
dnf install -y emacs
dnf install -y arduino
#emacs plugins go here


#shell
dnf install -y zsh
dnf install -y util-linux-user #needed to change shell to zsh
dnf install -y lsd
dnf install -y tldr

if [ $vscode == 1 ]
then
    dnf install -y code
else
    dnf install -y codium
fi




#install misc. programs
dnf install -y mpv
dnf install -y vlc
dnf install -y qbittorrent
dnf install -y evolution
dnf install -y piper
dnf install -y gnome-shell-extension-gsconnect
dnf install -y gnome-tweaks
dnf install -y gnome-extensions-app

if [ $nonfree == 'y' ] || [ $nonfree == 'y' ]
then
    dnf install -y steam
    dnf install -y discord
fi

sudo -u $username ./$homeDir/Fedora-Initial-Setup-Script/UserFedoraSetup.sh $nonfree $rust $powershell