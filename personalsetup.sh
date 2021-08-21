reflector --latest 10 --country Brazil,Canada,Japan,Australia --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -S rkhunter ufw sway waybar xorg-xwayland firefox --noconfirm

systemctl enable ufw

ufw enable

rkhunter --propupd
