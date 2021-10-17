# Updating package database
pacman -Sy --noconfirm

pacman -S --noconfirm reflector btrfs-progs neovim

lsblk

echo ""
echo "=================="
echo ""
echo "Please enter disk to install: (example /dev/sda)"
echo ""

read DISK

# Formating disk
sgdisk -Z ${DISK}

# Creating root and boot partitions
sgdisk -a 2048 -o ${DISK}

sgdisk -n 1:0:+550M ${DISK}

sgdisk -n 2:0:0     ${DISK}

sgdisk -t 1:ef00 ${DISK}

sgdisk -c 1:"UEFI" ${DISK}

sgdisk -c 2:"ROOT" ${DISK}

CRYPTROOT=${DISK}p2
BOOT=${DISK}p1

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

umount /mnt

mount -o noatime,commit=120,compress=zstd,space_cache,subvol=@ /dev/mapper/cryptroot /mnt

mkdir /mnt/{boot,home,var,opt,tmp}

mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@opt /dev/mapper/cryptroot /mnt/opt
mount -o noatime,commit=120,compress=zstd,space_cache,ssd,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
mount -o subvol=@var /dev/mapper/cryptroot /mnt/var

mount ${BOOT} /mnt/boot

# Installing system packages
reflector --latest 200 --protocol https --sort rate --country Brazil,Canada,Japan,Australia,Norway,Iceland --save /etc/pacman.d/mirrorlist
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

arch-chroot /mnt
