pacman -S rkhunter ufw sway waybar xorg-xwayland --noconfirm

systemctl enable ufw

ufw enable

rkhunter --propupd
