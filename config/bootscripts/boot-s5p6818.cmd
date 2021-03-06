# DO NOT EDIT THIS FILE
#
# Please edit /boot/armbianEnv.txt to set supported parameters
#

# default values
setenv rootdev "/dev/mmcblk2p1"
setenv rootfstype "ext4"
setenv verbosity "1"
setenv fdt_addr "0x48000000"
setenv ramdisk_addr_r "0x49000000"
setenv kernel_addr_r "0x4a000000"

# fdtfile should come from compile-time u-boot patches
if test -z "${fdtfile}"; then
	setenv fdtfile "s5p6818-nanopi-m3.dtb"
fi

echo "Boot script loaded from SD card"

if ext4load mmc 1:1 ${kernel_addr_r} boot/armbianEnv.txt; then
	env import -t ${kernel_addr_r} ${filesize}
fi

setenv bootargs "console=ttySAC0,115200n8 root=${rootdev} rootwait rootfstype=${rootfstype} loglevel=${verbosity} usb-storage.quirks=${usbstoragequirks} ${extraargs}"

if ext4load mmc 1:1 ${fdt_addr} boot/dtb/nexell/${fdtfile} || ext4load mmc 1:1 ${fdt_addr} boot/dtb/nexell/s5p6818-nanopi3-rev07.dtb; then echo "Loading DTB"; fi
ext4load mmc 1:1 ${ramdisk_addr_r} boot/uInitrd
ext4load mmc 1:1 ${kernel_addr_r} boot/Image

booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr}

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
