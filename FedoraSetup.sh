#!/bin/bash

passwd -l root #lock root password

#user prompts

computerType=4
until [ $computerType == 1 ] || [ $computerType == 2 ]
do
    read -p "Enter 1 if this is a laptop or 2 if this is a desktop: " computerType
done
homeDir='a'
sureHome='N'
until [ $sureHome == 'y' ] || [ $sureHome == 'Y' ]
do
    read -p "Enter the absolute path to your home directory: " firstHome
    read -p "Are you sure? [y\N]: " sureHome
done

#repo prompts
nonfree='a'
until [ $nonfree == 'y' ] || [ $nonfree == 'Y' ] || [ $nonfree == 'n' ] || [ $nonfree == 'N' ]
do
    read -p "Install non-free software? [y\N]: " nonfree
done

flatpak='a'
until [ $flatpak == 'y' ] || [ $flatpak == 'Y' ] || [ $flatpak == 'n' ] || [ $flatpak == 'N' ]
do
    read -p "Enable Flatpak? (contains some non-free software) [y/N]: " flatpak
done

#programming language prompts
languages='a'
until [ $languages == 'y' ] || [ $languages == 'Y' ] || [ $languages == 'n' ] || [ $languages == 'N' ]
do
    read -p "Install all available programming languages? [y\N]: " languages
done

if [ $languages == 'n' ] || [ $languages == 'N' ]
then
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

powershell='a'
until [ $powershell == 'y' ] || [ $powershell == 'Y' ] || [ $powershell == 'n' ] || [ $powershell == 'N' ]
do
    read -p "Install PowerShell? [y/N]: " powershell
done


dnf upgrade -y



#remove unneeded programs
dnf remove -y totem totem-plugins #gnome videos
dnf remove -y cheese
rm -r $homeDir/.config/totem


#add repos

#RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

if [ $nonfree == 'y' ] || [ $nonfree == 'Y' ]
then
    dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

#Flatpak
if [ $flatpak == 'y' ] || [ $flatpak == 'Y' ]
then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

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
    wget -P /etc/yum.repos.d/ https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/openjdk/adoptopenjdk.repo
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

#install programming languages
if [ $languages == 'y' ] || [ $languages == 'Y' ]
then
    
    #install rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o temp.sh
    chmod 744 temp.sh
    ./temp.sh -y
    rm temp.sh
    source $homeDir/.cargo/env
    
    dnf install -y java-latest-openjdk-devel
    dnf install -y dotnet-sdk
    dnf install -y golang
    dnf install -y ruby-devel
fi

if [ $rust == 'y' ] || [ $rust == 'Y' ]
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o temp.sh
    chmod 744 temp.sh
    ./temp.sh -y
    rm temp.sh
    source $homeDir/.cargo/env
fi

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

pythonVersion="3.9"
pip install wheel
pip install powerline-status
mkdir $homeDir/.config/powerline
mkdir $homeDir/.local/lib/python$pythonVersion/site-packages/scripts
cp $homeDir/.local/bin/powerline-config $homeDir/.config/powerline
cp $homeDir/.local/bin/powerline-config $homeDir/.local/lib/python$pythonVersion/site-packages/scripts
cp $homeDir/.local/bin/powerline-config $homeDir/.cargo/bin

if [ $vscode == 1 ]
then
    dnf install -y code
else
    dnf install -y codium
fi

if [ $powershell == 'y' ] || [ $powershell == 'Y' ]
then
    dotnet tool install --global PowerShell
fi


jboxVer=1.18.7609
if [ $nonfree == 'y' ] || [ $nonfree == 'Y' ]
then
    wget -p $homeDir https://download.jetbrains.com/toolbox/jetbrains-toolbox-$jboxVer.tar.gz
    tar -zxvf jetbrains-toolbox-$jboxVer.tar.gz
    rm jetbrains-toolbox-$jboxVer.tar.gz
    ./jetbrains-toolbox-$jboxVer/jetbrains-toolbox
    rm jetbrains-toolbox-$jboxVer/jetbrains-toolbox
    rmdir jetbrains-toolbox
fi

#insert python script here to install IDEs through toolbox here



#install misc. programs
dnf install -y mpv
dnf install -y vlc
dnf install -y qbittorrent
dnf install -y evolution
dnf install -y piper
flatpak install -y flathub org.raspberrypi.rpi-imager
dnf install -y gnome-shell-extension-gsconnect
dnf install -y gnome-tweaks
dnf install -y gnome-extensions-app

if [ $nonfree == 'y' ] || [ $nonfree == 'y' ]
then
    dnf install -y steam
    dnf install -y discord
    flatpak install -y flathub com.microsoft.Teams
fi



#install fonts
nerdfontsVersion="v2.1.0"
mkdir "$homeDir/.fonts"
mkdir "$homeDir/.fonts/Cascadia Code"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfontsVersion/CascadiaCode.zip
unzip "CascadiaCode.zip" -d "$homeDir/.fonts/Cascadia Code"
rm "CascadiaCode.zip"
cd "$homeDir/.fonts/Cascadia Code/"
rm *Windows*
mkdir "$homeDir/.fonts/IBM Plex Mono"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfontsVersion/IBMPlexMono.zip
rm "IBMPlexMono.zip"
cd "$homeDir/.fonts/IBM Plex Mono/"
rm *Windows*
unzip "IBMPlexMono.zip" -d "$homeDir/.fonts/IBM Plex Mono"
mkdir "$homeDir/.fonts/JetBrains Mono"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfontsVersion/JetBrainsMono.zip
unzip "JetBrainsMono.zip" -d "$homeDir/.fonts/JetBrains Mono"
rm "JetBrainsMono.zip"
cd "$homeDir/.fonts/JetBrains Mono/"
rm *Windows*
cd $homeDir

#configure gnome

#desktop

#display
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

#power
if [ $computerType == 2]
then
    gsettings set org.gnome.desktop.session idle-delay "uint32 0"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "suspend"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
fi

#keyboard and mouse
gsettings set org.gnome.desktop.peripherals.mouse accel-profile "flat"
gsettings set org.gnome.desktop.peripherals.touchpad click-method "areas"

#themes and fonts
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface monospace-font-name "CaskaydiaCove Nerd Font Book 10"
gsettings set org.gnome.desktop.interface font-name "Liberation Sans 11"
gsettings set org.gnome.desktop.interface document-font-name "Liberation Sans 11"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Liberation Sans Bold 11"
#add more font changes

#top bar
gsettings set org.gnome.desktop.interface show-battery-percentage true

#favorites (unsure how)

#world clocks (unsure how)

#terminal



#configure programs

#mpv
wget -P $homeDir/.config/mpv https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/mpv/input.conf https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/mpv/mpv.conf
mv input.conf mpv.conf $homeDir/.config/mpv
wget https://github.com/bloc97/Anime4K/releases/download/3.1/Anime4K_v3.1.zip
mkdir $homeDir/.config/mpv/shaders
unzip Anime4K_v3.1.zip -d $homeDir/.config/mpv/shaders
rm Anime4K_v3.1.zip

#vscode or vscodium
if [ $vscode == 1 ]
then
    wget -P $homeDir/.config/Code/User https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vscode/settings.json
else
    #might not work, need to test
    wget -P $homeDir/.config/Codium/User https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vscodium/settings.json
fi

#shell
chsh -s $(which zsh) #change default shell to zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" #install oh-my-zsh
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k #install powerlevel10k
wget -P $homeDir https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/zsh/.zshrc \
https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/zsh/.p10k.zsh #download configs

#vim
wget -P $homeDir/.vimrc https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vim/.vimrc

#emacs

