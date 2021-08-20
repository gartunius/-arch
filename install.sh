# Setting up the correct timezone
timedatectl set-ntp true

# Updating package database
pacman -Sy --noconfirm

# Updating mirrorlist
echo "\n=================="
echo "Setting up mirrors"
echo "\n==================\n\n"
pacman -S reflector --noconfirm
reflector --latest 200 --country Brazil,Canada,Japan,Australia,Iceland,Norway --protocol https --sort rate --save /etc/pacman.d/mirrorlist

#Setting up dependencies
echo "\n=================="
echo "Installing prerequisites"
echo "\n==================\n\n"
pacman -S --noconfirm btrfs-progs

echo "\n=================="
echo " Select your disk to format"
echo "\n==================\n\n"

lsblk

echo "Please enter disk: (example /dev/sda)"

read DISK

echo -e "Formatting disk...$HR"

dd if=/dev/zero of=${DISK} status=progress

sgdisk -a 2048 -o ${DISK}

sgdisk -n 1:0:+550M ${DISK}

sgdisk -n 2:0:0     ${DISK}

sgdisk -t 1:ef00 ${DISK}

sgdisk -t 2:8300 ${DISK}

sgdisk -c 1:"UEFISYS" ${DISK}

sgdisk -c 2:"ROOT" ${DISK}

