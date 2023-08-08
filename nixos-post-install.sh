sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --update
# mcfly: configuration.nix does not work as of 23.05
eval "$(mcfly init zsh)"
eval "$(mcfly init bash)"