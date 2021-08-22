reflector --latest 10 --country Brazil,Canada,Japan,Australia --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -S archlinux-keyring --noconfirm

pacman -S rkhunter ufw sway waybar xorg-xwayland firefox ttf-ubuntu-font-family swaylock rsync

systemctl enable ufw

ufw enable

rkhunter --propupd
