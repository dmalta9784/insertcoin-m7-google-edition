#!/tmp/busybox sh

#Global variables 
export PATH=/system/sbin:/system/bin:/system/xbin:/tmp
export LD_LIBRARY_PATH=/system/lib
export ANDROID_ROOT=/system
export ANDROID_ASSETS=/system/app
export ANDROID_DATA=/data
export ASEC_MOUNTPOINT=/mnt/asec
export LOOP_MOUNTPOINT=/mnt/obb

#BOOTCLASSPATH (read them from init.rc)
export BOOTCLASSPATH="/system/framework/core.jar:/system/framework/conscrypt.jar:/system/framework/okhttp.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/framework2.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/mms-common.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar:/system/framework/webviewchromium.jar:/system/framework/htcirlibs.jar"
                      
# Order matters here, up to BOOTCLASSPATH
FRAMEWORK="/system/framework/core.jar
/system/framework/core-junit.jar
/system/framework/bouncycastle.jar
/system/framework/ext.jar
/system/framework/HTCDev.jar
/system/framework/framework.jar
/system/framework/framework2.jar
/system/framework/android.policy.jar
/system/framework/services.jar
/system/framework/apache-xml.jar
/system/framework/com.htc.android.bluetooth.jar
/system/framework/HTCCommonctrl.jar
/system/framework/HTCExtension.jar
/system/framework/com.orange.authentication.simcard.jar
/system/framework/usbnet.jar
/system/framework/telephony-common.jar
/system/framework/voip-common.jar
/system/framework/mms-common.jar"

# Odex Framework Rest
REST="/system/framework/*.jar"

# Odex apps
APPS="/system/app/*.apk"

# Odex priv-apps
PRIV="/system/priv-app/*.apk"

# Set up busybox symlinks
for i in $(busybox --list)
do
	ln -s busybox /tmp/$i
done


# Framework
for i in $FRAMEWORK
do
	odex=`echo $i | sed -e 's/.jar/.odex/g'`
	dexopt-wrapper $i $odex $BOOTCLASSPATH	
	zip -d $i classes.dex
done

# Framework Rest
for i in $REST
do
	odex=`echo $i | sed -e 's/.jar/.odex/g'`
	dexopt-wrapper $i $odex $BOOTCLASSPATH
	zip -d $i classes.dex
done

# System apps
for i in $APPS
do
	odex=`echo $i | sed -e 's/.apk/.odex/g'`
	dexopt-wrapper $i $odex $BOOTCLASSPATH
	zip -d $i classes.dex
done

# System priv-apps
for i in $PRIV
do
	odex=`echo $i | sed -e 's/.apk/.odex/g'`
	dexopt-wrapper $i $odex $BOOTCLASSPATH
	zip -d $i classes.dex
done

# checks if dalvik is empty
if [ "$(busybox ls -A /data/dalvik-cache)" ] ; then
	busybox rm -r /data/dalvik-cache/*
fi

# ammend odex to build prop version
sed -i '/ro.product.version/s/$/ ODEXED/' /system/build.prop
