#!/bin/bash
#
# configures NFS server
# use for RHEL based OS

NFS_SERVER=`hostname`
NFS_CLIENTS='app1 app2'
NFS_SHARES='/opt/share/foo /opt/share/bar'
PACKAGES='nfs-utils '

# OS major release
OS_RELEASE=`cat /etc/redhat-release | awk '{print $3}' | cut -d'.' -f1`

# some NFS tuning
sed -i 's/RPCMOUNTDOPTS=\"\"/RPCMOUNTDOPTS=\"-p 20048\"/g' /etc/sysconfig/nfs
sed -i 's/STATDARG=\"\"/STATDARG=\"-p 50825\"/g' /etc/sysconfig/nfs

# bring the NFS server services up
if [ "$OS_RELEASE" == "6" ]; then
	for s in rpcbind nfs; do
		service $s start
		chkconfig $s on
	done
else
	for s in rpcbind nfs-server; do
		systemctl enable $s
		systemctl start $s
	done
fi

# SELinux settings
echo -e "\nConfiguring SELinux. Please be patient."
setsebool -P virt_use_nfs=true
for c in $NFS_CLIENTS; do
	echo -en "   on $c ... "
	ssh root@$c "setsebool -P virt_use_nfs=true"
	echo "done"
done

# create the shares
for share in $NFS_SHARES; do
	mkdir -p $share
	chown nfsnobody:nfsnobody $share
	chmod 700 $share
	echo "$share *(rw,async,all_squash)" >> /etc/exports
done

# export the shares
exportfs -a

sleep 2

# mounting the shares
echo -e "\nShares ready. Mount commands:"
for share in $NFS_SHARES; do
	echo -e "mount -t nfs $NFS_SERVER:$share <mountpoint>"
done
