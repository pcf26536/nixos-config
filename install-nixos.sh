sudo mount /dev/disk/by-label/root /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot/
sudo mkdir -p /mnt/nix
sudo mount /dev/disk/by-label/nix /mnt/nix/
sudo mkdir -p /mnt/var
sudo mount /dev/disk/by-label/var /mnt/var/
sudo mkdir -p /mnt/home
sudo mount /dev/disk/by-label/home /mnt/home/
sudo nixos-generate-config --root /mnt
sudo rm /mnt/etc/nixos/configuration.nix
sudo mount -p /dev/disk/by-label/data /run/media/nixos/
sudo cp /run/media/nixos/data/Repositories/nixos-config/configuration.nix /mnt/etc/nixos/
cd /mnt
ls
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --update
sudo nixos-install
