#!/usr/bin/bash
# Wed Nov 18 15:14:38 CET 2015
# christian.frei@umb.ch
#
# cleans the unneeded instance files in /var/lib/nova/instances

DIR="/var/lib/nova/instances"
CREDS="/root/keystonerc_admin"

. $CREDS
INSTANCES=$(nova list --all-tenants | grep = | cut -d'|' -f2 | sed 's/^ *//g')

echo -e "diskspace used in $DIR:"
du -sh $DIR
echo -e "checking for inactive instance-files in $DIR..."
for f in $(ls $DIR | grep -); do
   active=
   for i in $INSTANCES; do
      [ $f == $i ] && active=true && break
   done
   if [ ! $active ]; then
      echo -e "   rm -rf $DIR/$f"
      rm -rf $DIR/$f >/dev/null
   fi
done
echo -e "done"
df -hT $DIR
echo -e "new diskspace used in $DIR:"
du -sh $DIR
exit 0
