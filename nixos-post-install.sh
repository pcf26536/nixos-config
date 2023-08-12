sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --update
# mcfly: configuration.nix does not work as of 23.05
eval "$(mcfly init zsh)"
eval "$(mcfly init bash)"
# spotify-adblock
nix-shell -p cargo gnumake
git clone https://github.com/abba23/spotify-adblock.git
cd spotify-adblock/
make
sudo make install
touch ~/.local/share/applications/spotify-adblock.desktop
cat << EOF >> ~/.local/share/applications/spotify-adblock.desktop
[Desktop Entry]
Name=Spotify Adblock
GenericName=Music Player
Comment=Listen to music from Spotify without ads
Exec=LD_PRELOAD=/usr/local/lib/spotify-adblock.so spotify
Icon=spotify-client
Terminal=false
Type=Application
Categories=Audio;Music;Player;AudioVideo;
MimeType=x-scheme-handler/spotify;
EOF
rm -rf spotify-adblock/
