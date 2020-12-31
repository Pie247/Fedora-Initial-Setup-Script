#!/bin/bash

rust=$1


#install programming languages

#install rust
if [ $rust == 'y' ] || [ $rust == 'Y' ]
    then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o temp.sh
        chmod 744 temp.sh
        ./temp.sh -y
        rm temp.sh
        source $homeDir/.cargo/env
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
chsh -s $(which zsh) $username #change default shell to zsh
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh #install oh-my-zsh
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k #install powerlevel10k
wget -P $homeDir https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/zsh/.zshrc \
https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/zsh/.p10k.zsh #download configs

#vim
wget -P $homeDir/.vimrc https://raw.githubusercontent.com/Pie247/Fedora-Initial-Setup-Script/main/configs/vim/.vimrc

#emacs

