#!/sbin/sh
echo "" >> /system/build.prop
echo "# Disable Bytecode Verification" >> /system/build.prop
echo "dalvik.vm.verify-bytecode=false" >> /system/build.prop
echo "dalvik.vm.dexopt-flags=v=n,o=v,m=y" >> /system/build.prop
