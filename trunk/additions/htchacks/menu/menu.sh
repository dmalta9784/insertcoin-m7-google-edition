#!/sbin/sh
echo "" >> /system/build.prop
echo "# Disable Softkeybar" >> /system/build.prop
echo "qemu.hw.mainkeys=1" >> /system/build.prop
