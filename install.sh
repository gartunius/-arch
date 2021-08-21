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

sgdisk -c 1:"UEFI" ${DISK}

sgdisk -c 2:"ROOT" ${DISK}

echo ""
echo "=================="
echo ""
echo "Encrypting disk"
echo ""
echo "=================="
echo ""

CRYPTROOT=${DISK}2
CRYPTBOOT=${DISK}1

cryptsetup --type=luks2 -s 512 -h sha512 -i 8000 --use-random -y luksFormat ${CRYPTROOT}

cryptsetup open ${CRYPTROOT} cryptroot

echo ""
echo "=================="
echo ""
echo "Formating disks"
echo ""
echo "=================="
echo ""

mkfs.vfat -F32 -n EFI ${CRYPTBOOT}

mkfs.btrfs -L ROOT /dev/mapper/cryptroot

echo ""
echo "=================="
echo ""
echo "BTRFS Setup"
echo ""
echo "=================="
echo ""

mount /dev/mapper/cryptroot /mnt

btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@pkg
btrfs sub create /mnt/@snapshots

umount /mnt

mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@ /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,.snapshots,btrfs}
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvolid=5 /dev/mapper/cryptroot /mnt/btrfs
