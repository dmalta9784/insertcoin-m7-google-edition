#!/sbin/sh
#Enforce Dual Transfer Mode ON
sed -i '/ro.ril.enable.dtm/s/0/1/g' /system/build.prop