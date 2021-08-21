# Setting up the correct timezone
timedatectl set-ntp true

# Updating package database
pacman -Sy --noconfirm

# Updating mirrorlist
echo ""
echo "=================="
echo ""
echo "Setting up mirrors"
echo ""
echo "=================="
pacman -S reflector --noconfirm

echo ""
echo "=================="
echo ""
echo "Starting reflector"
echo ""
echo "=================="
reflector --latest 10 --country Brazil,Canada,Japan,Australia --protocol https --sort rate --save /etc/pacman.d/mirrorlist

cat /etc/pacman.d/mirrorlist

#Setting up dependencies
echo ""
echo "=================="
echo ""
echo "Installing prerequisites"
echo ""
echo "=================="
pacman -S --noconfirm btrfs-progs

echo ""
echo "=================="
echo ""
echo " Select your disk to format"
echo ""
echo "=================="
echo ""

lsblk

echo ""
echo "=================="
echo ""
echo "Please enter disk: (example /dev/sda)"
echo ""

read DISK

echo -e "Formatting disk...$HR"

#dd if=/dev/zero of=${DISK} status=progress
sgdisk -Z ${DISK}

sgdisk -a 2048 -o ${DISK}

sgdisk -n 1:0:+550M ${DISK}

sgdisk -n 2:0:0     ${DISK}

sgdisk -t 1:ef00 ${DISK}

sgdisk -t 2:8300 ${DISK}

sgdisk -c 1:"UEFISYS" ${DISK}

sgdisk -c 2:"ROOT" ${DISK}

echo ""
echo "=================="
echo ""
echo "Encrypting disk"
echo ""
echo "=================="
echo ""

cryptsetup --type=luks2 -s 512 -h sha512 -i 8000 --use-random -y luksFormat ${DISK}

