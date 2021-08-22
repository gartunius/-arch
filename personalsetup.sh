reflector --latest 10 --country Brazil,Canada,Japan,Australia --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -S archlinux-keyring --noconfirm

pacman -S rkhunter ufw sway waybar xorg-xwayland firefox ttf-ubuntu-font-family swaylock rsync keepassxc pipewire pipewire-pulse pipewire-media-session thunar thunar-archive-plugin thunar-media-tags thunar-volman tmux alacritty pavucontrol chromium adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts deluge-gtk cronie

systemctl enable ufw

ufw enable

rkhunter --propupd

systemctl enable NetworkManager
