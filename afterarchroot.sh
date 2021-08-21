echo gartunius > /etc/hostname

echo LANG=en_US.UTF-8 > /etc/locale.conf

#sed -i 's/#en_US.UTF-8/en_US.UTF-8/'
nvim /etc/locale.gen

locale-gen

ln -sf /usr/share/zoneinfo/America/SaoPaulo /etc/localtime

echo ""
echo "=================="
echo ""
echo "Set root password"
echo ""
echo "=================="
echo ""

passwd

echo "127.0.0.1	gabriel.localdomain	gabriel" >> /etc/hosts
echo "::1		localhost.localdomain	localhost" >> /etc/hosts

nvim /etc/hosts

echo 'HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems)' >> /etc/mkinitcpio.conf

nvim /etc/mkinitcpio.conf

mkinitcpio -p linux

echo ""
echo "=================="
echo ""
echo "Installing bootloader"
echo ""
echo "=================="
echo ""

bootctl --path=/boot install

touch /boot/loader/entries/arch.conf

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=<UUID-OF-ROOT-PARTITION>:luks:allow-discards root=/dev/mapper/cryptroot rootflags=subvol=@ rd.luks.options=discard rw"

echo "${blkid}" >> /boot/loader/entries/arch.conf

nvim /boot/loader/entries/arch.conf

echo """
default  arch.conf
timeout  4
""" >> /boot/loader/loader.conf


bootctl update

