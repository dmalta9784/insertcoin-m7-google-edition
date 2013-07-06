#!/sbin/sh
#Update ROM version
sed -i '/<item type="boolean" name="support_minor_quicksettings">/s/false/true/g' /system/customize/ACC/default.xml

