#!/sbin/sh

echo "" >> /system/build.prop
echo "# Disable Fast Dormancy" >> /system/build.prop
echo "ro.ril.fast.dormancy.rule=0" >> /system/build.prop