#!/bin/bash

nonfree=$1
rust=$2
powershell=$3
vscode=$4
username=$5


#install programming languages

#install rust
if [ $rust == 'y' ] || [ $rust == 'Y' ]
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o temp.sh
    chmod 744 temp.sh
    ./temp.sh -y
    rm temp.sh
    source $HOME/.cargo/env
fi

#install powershell
if [ $powershell == 'y' ] || [ $powershell == 'Y' ]
then
    dotnet tool install --global PowerShell
fi


#install flatpaks
flatpak install -y flathub org.raspberrypi.rpi-imager
if [ $nonfree == 'y' ] || [ $nonfree == 'Y' ]
then
    flatpak install -y flathub com.microsoft.Teams
fi


#install fonts
nerdfontsVersion="v2.1.0"
mkdir "$HOME/.fonts"
mkdir "$HOME/.fonts/Cascadia Code"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfontsVersion/CascadiaCode.zip
unzip "CascadiaCode.zip" -d "$HOME/.fonts/Cascadia Code"
rm "CascadiaCode.zip"
cd "$HOME/.fonts/Cascadia Code/"
rm *Windows*
mkdir "$HOME/.fonts/IBM Plex Mono"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfontsVersion/IBMPlexMono.zip
rm "IBMPlexMono.zip"
cd "$HOME/.fonts/IBM Plex Mono/"
rm *Windows*
unzip "IBMPlexMono.zip" -d "$HOME/.fonts/IBM Plex Mono"
mkdir "$HOME/.fonts/JetBrains Mono"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$nerdfontsVersion/JetBrainsMono.zip
unzip "JetBrainsMono.zip" -d "$HOME/.fonts/JetBrains Mono"
rm "JetBrainsMono.zip"
cd "$HOME/.fonts/JetBrains Mono/"
rm *Windows*
cd $HOME

#configure gnome

#desktop

#display
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

#power
if [ $computerType == 2 ]
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
wget -P $HOME/.config/mpv https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/mpv/input.conf https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/mpv/mpv.conf
wget https://github.com/bloc97/Anime4K/releases/download/3.1/Anime4K_v3.1.zip
mkdir $HOME/.config/mpv/shaders
unzip Anime4K_v3.1.zip -d $HOME/.config/mpv/shaders
rm Anime4K_v3.1.zip

#vscode or vscodium
if [ $vscode == 1 ]
then
    wget -P $HOME/.config/Code/User https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vscode/settings.json
else
    #might not work, need to test
    wget -P $HOME/.config/Codium/User https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vscodium/settings.json
fi

#vim
wget -P $HOME/.vimrc https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vim/.vimrc

#emacs

#install oh-my-zsh
wget -P $HOME https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/zsh/.zshrc \
https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/zsh/.p10k.zsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh #install oh-my-zsh
chmod 744 install.sh
bash install.sh --unattended --keep-zshrc
rm install.sh
sed -i "12s/.*/export ZSH=/home/$username.oh-my-zsh/ $HOME/.zshrc"
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k #install powerlevel10k
#download plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
#download configs


chsh -s $(which zsh) $username