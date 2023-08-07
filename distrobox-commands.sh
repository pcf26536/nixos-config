distrobox-create -n arch -i archlinux
distrobox enter arch
sudo pacman -Syyu
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst
sudo cat << EOF >> /etc/pacman.conf

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
sudo pacman -Syyu
sudo pacman -S yay fakeroot binutils neofetch rate-mirrors xdman audiorelay
rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist
sudo pacman -Syyu
yay -S adobe-source-sans-pro-fonts ttf-dejavu ttf-opensans noto-fonts freetype2 terminus-font ttf-bitstream-vera ttf-dejavu ttf-droid ttf-fira-mono ttf-fira-sans ttf-freefont ttf-inconsolata ttf-liberation libertinus-font
yay -S googlekeep
distrobox-export -a xdman
distrobox-export -a googlekeep
