pacman -S rkhunter ufw --noconfirm

systemctl enable ufw

ufw enable

rkhunter --propupd
