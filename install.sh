lsblk

echo "=================="
echo "Please enter disk to install: (example /dev/sda)"
echo ""

read DISK

# Formating disk
sgdisk -Z ${DISK}

# Creating root and boot partitions
sgdisk -a 2048 -o ${DISK}
sgdisk -n 1:0:+550M ${DISK}
sgdisk -n 2:0:0 ${DISK}
sgdisk -t 1:ef00 ${DISK}
sgdisk -c 1:"UEFI" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

ROOT=${DISK}2
BOOT=${DISK}1

# Formating boot partition
mkfs.vfat -F32 -n efi ${BOOT}

# Formating root partition
mkfs.ext4 -L nixos ${ROOT}

# Mounting partitions
mount /dev/disk/by-label/nixos /mnt

mkdir /mnt/boot
mount /dev/disk/by-label/efi /mnt/boot

# Generating basic config file
nixos-generate-config --root /mnt

# Installing basic system
nixos-install
