#!/tmp/bash
# Remove content of /data partition excluding data/media files
cd /data
FILES=(*)
for i in *; do
if [ "$i" != "media" ]
then rm -R "$i"
fi
done