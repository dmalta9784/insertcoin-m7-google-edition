#!/tmp/busybox sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin:/tmp:$PATH
export LD_LIBRARY_PATH=/system/lib
export ANDROID_ROOT=/system
export ANDROID_ASSETS=/system/app
export ANDROID_DATA=/data
export ASEC_MOUNTPOINT=/mnt/asec
export LOOP_MOUNTPOINT=/mnt/obb
#export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/framework2.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar:/system/framework/com.htc.android.bluetooth.jar:/system/framework/HTCDev.jar:/system/framework/HTCCommonctrl.jar:/system/framework/HTCExtension.jar:/system/framework/wimax.jar:/system/framework/com.orange.authentication.simcard.jar:/system/framework/usbnet.jar
#export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/framework2.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar:/system/framework/com.htc.android.bluetooth.jar:/system/framework/HTCDev.jar:/system/framework/HTCCommonctrl.jar:/system/framework/HTCExtension.jar:/system/framework/wimax.jar:/system/framework/usbnet.jar:/system/framework/telephony-common.jar:/system/framework/mms-common.jar
export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/framework2.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar:/system/framework/com.htc.android.bluetooth.jar:/system/framework/HTCDev.jar:/system/framework/HTCCommonctrl.jar:/system/framework/HTCExtension.jar:/system/framework/wimax.jar:/system/framework/usbnet.jar:/system/framework/telephony-common.jar:/system/framework/mms-common.jar

# Order matters here, up to BOOTCLASSPATH
FRAMEWORK="/system/framework/core.jar
/system/framework/core-junit.jar
/system/framework/bouncycastle.jar
/system/framework/ext.jar
/system/framework/framework.jar
/system/framework/framework2.jar
/system/framework/android.policy.jar
/system/framework/services.jar
/system/framework/apache-xml.jar
/system/framework/com.htc.android.bluetooth.jar
/system/framework/HTCDev.jar
/system/framework/HTCCommonctrl.jar
/system/framework/HTCExtension.jar
/system/framework/wimax.jar
/system/framework/usbnet.jar
/system/framework/telephony-common.jar
/system/framework/mms-common.jar"

# Odex Framework Rest
REST="/system/framework/*.jar"

# Odex apps
APPS="/system/app/*.apk"

# Set up busybox symlinks
for i in $(busybox --list)
do
	ln -s busybox /tmp/$i
done

# Framework
for i in $FRAMEWORK
do
	odex=`echo $i | sed -e 's/.jar/.odex/g'`
	dexopt-wrapper $i $odex
	zip -d $i classes.dex
done

# Framework Rest
for i in $REST
do
	odex=`echo $i | sed -e 's/.jar/.odex/g'`
	dexopt-wrapper $i $odex
	zip -d $i classes.dex
done

# System apps
for i in $APPS
do
	odex=`echo $i | sed -e 's/.apk/.odex/g'`
	dexopt-wrapper $i $odex
	zip -d $i classes.dex
done

# wipe Dalvik-cache
sed -i '/ro.product.version/s/$/ ODEXED/' /system/build.prop
