nix-env --delete-generations old
nix-store --gc
sudo nix-collect-garbage --delete-older-than $DAYS
sudo nixos-rebuild boot 
