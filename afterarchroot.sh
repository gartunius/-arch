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

echo 'HOOKS="base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems"' >> /etc/mkinitcpio.conf

nvim /etc/mkinitcpio.conf
