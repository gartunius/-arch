# Setting up the correct timezone
timedatectl set-ntp true

# Updating package database
pacman -Sy --noconfirm

# Updating mirrorlist
pacman -S reflector --noconfirm

cat /etc/pacman.d/mirrorlist

#Setting up dependencies
pacman -S --noconfirm btrfs-progs neovim

lsblk

echo ""
echo "=================="
echo ""
echo "Please enter disk to install: (example /dev/sda)"
echo ""

read DISK

# Formating disk
dd if=/dev/zero of=${DISK} status=progress
sgdisk -Z ${DISK}

# Creating root and boot partitions
sgdisk -a 2048 -o ${DISK}

sgdisk -n 1:0:+550M ${DISK}

sgdisk -n 2:0:0     ${DISK}

sgdisk -t 1:ef00 ${DISK}

sgdisk -c 1:"UEFI" ${DISK}

sgdisk -c 2:"ROOT" ${DISK}

CRYPTROOT=${DISK}2
BOOT=${DISK}1

# Encrypting
cryptsetup --type=luks2 -s 512 -h sha512 -i 8000 --use-random -y luksFormat ${CRYPTROOT}

cryptsetup open ${CRYPTROOT} cryptroot

mkfs.vfat -F32 -n EFI ${BOOT}

# BTRFS setup
mkfs.btrfs -L ROOT /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@opt
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@.snapshots

umount /mnt

mount -o noatime,commit=120,compress=zstd,space_cache,subvol=@ /dev/sda3 /mnt
# You need to manually create folder to mount the other subvolumes at
mkdir /mnt/{boot,home,var,opt,tmp,.snapshots}

mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@opt /dev/mapper/cryptroot /mnt/opt
mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@.snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o subvol=@var /dev/mapper/cryptroot /mnt/var

#mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@ /dev/mapper/cryptroot /mnt
#mkdir -p /mnt/{boot,home}
#mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/cryptroot /mnt/home

mount ${BOOT} /mnt/boot

# Installing system packages
pacstrap /mnt linux linux-lts linux-firmware base base-devel btrfs-progs amd-ucode neovim vim networkmanager network-manager-applet

genfstab -U /mnt >> /mnt/etc/fstab

echo ""
echo "=================="
echo ""
echo "Chroot (run the next script!!!!)"
echo "./afterarchroot.sh"
echo "=================="
echo ""

cp afterarchroot.sh /mnt/
cp personalsetup.sh /mnt/

arch-chroot /mnt
