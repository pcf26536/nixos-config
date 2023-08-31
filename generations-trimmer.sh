nix-env --delete-generations old
nix-store --gc
sudo nix-collect-garbage --delete-older-than 1d
sudo nixos-rebuild boot 
