############################################################################
#
# UNIX, LINUX
#
############################################################################


# dig dinge, nslookup
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# if zonetransfer is allowed:
dig axfr localdomain.ch | grep -i waseliwas	# search dns zone localdomain.ch for waseliwas


# jq dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
jq -r			# prints result without quotes


# ldap dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# read givennames from AD using LDAP
ldapsearch -v -x -LLL -H ldaps://<fqdn-of-ldap-host>:636 -D '<ad-domain>\<username>' -w <password> -s sub "(objectClass=user)" givenName
# read all data from LDAP using ldaps
ldapsearch -v -x -LLL -H ldaps://<fqdn-of-ldap-host>:636 -b "o=example,c=ch" -D 'cn=proxyagent,ou=special_users,o=example,c=ch' -w '<password>' -s sub "(objectClass=*)"


# firebase dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# google static content hosting service

cd ~/apontis/website
firebase list				# lists all projects
firebase serve				# provides local http server
firebase deploy	-P apontis-website	# deploys website to the cloud


# git dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# configure your local git client (~/.gitconfig)
git config --global user.name "chrigifrei"
git config --global user.email "chrigi...@...com"

# save credentials on OSX
$ git credential-osxkeychain store
host=host.example.ch
protocol=https
username=chrigi
password=****

# create a master (bare) repo on the repo management system
# now do locally
mkdir /path/to/your/project
cd /path/to/your/project
git init
git remote add origin git@bitbucket.org:linuxumb/linux-lab-config.git

# add and commit a file
git add <file>
git commit -m 'comment'
git push -u origin master

# sync your local copy
cd /path/to/your/repo
git pull

# checkout a branch
cd /path/to/your/repo
git fetch && git checkout <branch-name>
git branch -d <branch-name>					# delete a branch

# apply work from master to local branch
git co branchA
git rebase master

# apply a commit from branch A to branch B
git co branchA
git logs	# note the commit you wish to apply
git co branchB
git cherry-pick <commit>

# remove all remote tracking branches
git branch -r								# lists a bunch uf branches not available at remote repo
git remote prune origin						# removes branches not available on remote "origin"

# rename a branch locally and remote
git branch -m old_branch new_branch         # Rename branch locally    
git push origin :old_branch                 # Delete the old branch    
git push --set-upstream origin new_branch   # Push the new branch, set local branch to track the new remote

# git svn bridge
git svn rebase			# like svn update
git rebase -i HEAD~5	# merge the last 5 commits into one
git rebase --abort		# abort the above
git svn dcommit			# like svn commit

# keeping a github fork updated
# I forked https://github.com/TryGhost/Ghost.git to https://github.com/apontis/Ghost.git
git clone https://github.com/apontis/Ghost.git
cd Ghost/
git remote add upstream https://github.com/TryGhost/Ghost.git
# to update the local master branch
git fetch upstream
git rebase upstream/master

# git stashing
git stash					# put your work on "halde"
git stash list				# list your stashes
git stash pop				# get back your work and drop stash
git stash apply				# get back your work from last stash
git stash apply	stash@{2}	# get back your work from stash@{2}
git stash drop				# drop last stash
git stash clear				# clears all stashes


# ansible dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ansible all -m ping --ask-pass			# connectivity check if no SSH key exchange done yet



# docker dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# runs a Container interactively (-i) from image docker.io/devopsil/puppet
docker run -it --name puppet docker.io/devopsil/puppet /bin/bash
# runs a container detached (-d, like "in the background")
docker run --privileged=true -d -p <hostIP>:<hostPort>:<containerPort> --name spacewalk ruo91/spacewalk
# connect to a dettached container:
docker exec -it <container-id> /bin/bash
# attach a File to a container
docker run --privileged=true -d -v /host/file:/container/file --name spacewalk ruo91/spacewalk


# tivoli storage manager, tsm dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dsmc q b "/path/to/files/*"					# list most actual available backup
dsmc q b "/path/to/files/*" -ina			# list all available backups 
dsmc res "/path/to/files/*" /path/to/restore -ina -su=yes	# restore to different location
dsmc res "/path/to/files/*" /path/to/restore -ina -su=yes -date=4 -pitd=dd.mm.yyyy
								# restore version from dd.mm.yyyy to different location
dsmc q inclexcl					# checks and lists inclexcl config

# ilom dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
start /HOST/console		# connects to the serial console
# quit console with: ESC + (
reset System			# resets server


# md dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# linux software raid
mdadm -D /dev/md*		# prints details on all md devices


# passwd dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -e "new_password\nnew_password" | (passwd --stdin $USER)		# change $USER's password in a script


# documentation dinge, cfg2html, sosreport
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# on RHEL based systems
sosreport						# output .xc compressed archive in /tmp
tar -xf <sosreport.tar.xc>		# decompress archive

# at dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# scheduling a job:
at 09:00
at> nohup iostat -tkd xvda xvdb 30 480 > iostat_DOCT_2013-03-26.txt &
at> Ctrl+D
job 1 at 2013-03-26 09:00
at -l				# lists planned jobs
at -d <jobNr>		# deletes planned jobs


# grep dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cat <file> | egrep -v '#|^$' 		# removes all comments (#) and all blank lines
grep "user\|tester" /etc/group		# OR construction
grep -R blabla --exclude-dir logs	# recursive grep exclude the logs directory


# cp dinge, rsync dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# copy with excluded folders:
rsync -av --progress /sourcefolder/ /destinationfolder --exclude=<thefoldertoexclude>
                                # ^-- this copies the content of sourcefolder but not sourcefolder!

# my backup command:
sudo rsync -av --progress --delete --exclude=/media --exclude=/proc --exclude=/sys --exclude=/var/run --exclude=/windows --exclude=/ftp / /ftp/backup/june


# kernel panic
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# issue a kernel panic:
echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger

# or manually on the console:
'alt-printscreen-c'

# force kernel panic in case of a process hang (freeze):
/etc/sysctl.conf:
  kernel.softlockup_panic=1
  kernel.hung_task_panic=1
sysctl -p			# activates the changes in the running kernel


# ocfs2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
service ocfs2 status
cat /proc/fs/ocfs2/version			# gets the version of OCFS2
blockdev --rereadpt /dev/sdX		# Use blockdev(8) to rescan the partition table of the device on the other nodes in the cluster.
service multipathd reload			# if you use dm_multipath
tunefs.ocfs2 -S -v /dev/sdX			# To grow a file system to the end of the resized partition, do:

# prepare ocfs2 cluster:
service o2cb stop					# cluster service must be offline
mkdir -p /etc/ocfs2
# create /etc/ocfs2/cluster.conf:
cluster:
     node_count = 2
     name = <clusterName>			# do not use - (hyphen) in clustername

node:
     ip_port = 7777
     ip_address = 10.10.10.253
     number = 0
     name = <nodeName1>
     cluster = <clusterName>

node:
     ip_port = 7777
     ip_address = 10.10.10.254
     number = 1
     name = <nodeName2>
     cluster = <clusterName>
service o2cb load					# load the cluster config
service o2cb configure				# configure the cluster service to boot automatically
service o2cb online <clusterName>	# bring <clusterName> online

# mount OCFS2 volumes on boot:
chkconfig --add o2cb
chkconfig --add ocfs2
/etc/init.d/o2cb configure
# /etc/fstab entry:
/dev/sdX	/dir	ocfs2	_netdev		0	0

# infos
debugfs.ocfs2
debugfs: open /path/to/dev			# opens the mentioned device
debugfs: curdev						# display current device
debugfs: stats						# show some details on current device


# subversion, svn, subversion dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# create a repository (as root):
#	A svn repository is mainly a DB (in the db subfolder) which tracks its projects.
#	Files in the repo cannot be accessed directly. A workcopy (checkout) is necessary.
#	Some people prefere to create a repo for each project and some not
yum install -y subversion
mkdir /srv/svn
svnadmin create repo					# repo is a name not a command
export REPO_PATH=/srv/svn/repo
groupadd -g 20000 svnuser				# usergroup who has write/execute permission on the # repo dir
chgrp -R svnuser $REPO_PATH
chmod -R g+w $REPO_PATH/db

# add a project (as user of the group svnuser):
#	It is recommended to have the folders branches, tags and trunk within the project folder.
#	While all the relevant files are stored in the trunk folder.
svn import /home/chrigi/testProject file:///srv/svn/repo/testProject -m "initial import"
#	!! You won't see your files by directly peeking into the repository; they're all stored within a database.

# create a local working copy
rm -rf testProject/					# the first time delete the imported files 
svn checkout file:///srv/svn/repo/testProject/trunk testProject

# to checkout a copy of the testProject on a remote machine (using your ssh credentials on the svn server):
svn co svn+ssh://<user-on-svn-server>@<svn-server>/srv/svn/repo/testProject/trunk testProject

# work and commit
mkdir testProject/test-1.0/docs			# create a subfolder in testProject
svn add testProject/test-1.0/docs		# add subfolder or files to svn
cd testProject
svn commit -m "docs folder added"		# commit the changes within the project dir
svn info								# some infos on the project
svn status -vu							# list files and its status


# veritas filesystem
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
vxprint [-ht] 										# lists details on vx volumes
vxdisk -o alldgs list								# lists all disks and its status
vxfsstat [-t <seconds>] [-c <count>] <mountpoint>
fstyp -v <dev>										# prints VxFS version on HPUX


# tcpdump dinge, sniffing
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tcpdump tcp port 23 -n -A		# sniff for all telnet traffic


# netstat dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
netstat -a					# all available netstat infos
netstat -tu [-n]			# established connections (tcp/udp), -n list portnumbers not servicenames (eg. 22 instead of ssh)
netstat -p					# established connections including sockets
netstat -l					# listening ports (all protocols)
netstat -i [<sec>]			# network traffic all NICs in packets, <sec> repeat all <sec> seconds (see ifconfig: MTU is packetsize in bytes)
netstat -I=<NIC> [<sec>]	# network traffic for <NIC> in packets, <sec> repeat all <sec> seconds (see ifconfig: MTU is packetsize in bytes)
netstat -s					# netstat summary

# neu in RHEL 7:
ss --all					# ss = socket statistics


# postfix, mail dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# sample configuration on OL6 (RHEL6) /etc/postfix/main.cf
# parameters to customize:
	myhostname = sv5724.domain.local
	mydomain = domain.local
	inet_interfaces = localhost
	inet_protocols = ipv4			# choose between: all, ipv4, ipv6
	relayhost = vm5420.domain.local

# postfix reload				reload configuration files

to get MX relay from DNS:
# dig domain.ch MX


# sendmail
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# /etc/mail/sendmail.cf
DSmailhub.domain.com			# defines mail relay

# run a script on incoming mail:
# edit .forward file in receipients home:
"|/absolute/path/to/script.sh"
	# Note: do not use user specific $Variables in .forward file

# error: user unknown
# solution:
# no “_” in usernames
# sendmail cannot handle special characters in usernames!


# console resolution and color depth
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# /boot/grub/menu.lst
...
kernel ... vga=<vgaCode>

# vgaCodes:
#    Colors ( depth) 640x480 800x600 1024x768 1280x1024 1600x1200
#    ---------------+-------+-------+--------+---------+---------
#    256    ( 8 bit)|  769     771     773      775       796
#    32,768 (15 bit)|  784     787     790      793       797
#    65,536 (16 bit)|  785     788     791      794       798
#    16.8M  (24 bit)|  786     789     792      795       799

# change colors on console
/etc/DIR_COLORS.xterm

# using this ISO color codes:
# 	 30	for black foreground
# 	 31	for red foreground
# 	 32	for green foreground
# 	 33	for yellow (or brown) foreground
# 	 34	for blue foreground
# 	 35	for purple foreground
# 	 36	for cyan foreground
# 	 37	for white (or gray) foreground
# 	 40	for black background
# 	 41	for red background
# 	 42	for green background
# 	 43	for yellow (or brown) background
# 	 44	for blue background
# 	 45	for purple background
# 	 46	for cyan background
# 	 47	for white (or gray) background


# cifs share mount
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# package needed: cifs-utils
mount -t cifs //server-name/share-name /mnt/cifs -o username=shareuser,password=sharepassword,domain=<windowsDomain>
mount.cifs //192.168.101.100/sales /mnt/cifs -o username=shareuser,password=sharepassword,domain=<windowsDomain>
# if no password is given cifs mount will try using env variable PASSWD. if no password is provided at all cifs mount will prompt for it.

# /etc/fstab
//192.168.101.100/sales /mnt/sales	cifs	username=shareuser,password=sharepassword,domain=<windowsDomain> 	0 0
//192.168.101.100/sales /mnt/sales	cifs	username=shareuser,password=sharepassword,domain=<windowsDomain>,uid=xxx,gid=xxx 	0 0
//192.168.101.100/sales /mnt/sales	cifs	username=shareuser,credentials=/home/user/.cifsCredentials,domain=<windowsDomain> 	0 0
# /home/user/.cifsCredentials
password=<password>


ftp dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scripting ftp:
ftp -n <HOST> << EOF
quote USER <USER>
quote PASS <PASSWD>
put <FILE>
quit
EOF


xen dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# xm help [--long]			view available options and help text.
# xm list [-l]				use the xm list command to list active domains. -l long listing
# xm create [-c] DomainName/ID		start a virtual machine. If the -c option is used, the start up process will attach to the guest's console.
# xm console DomainName/ID		attach to a virtual machine's console. quit console: Ctrl + Alt + !
# xm destroy DomainName/ID		terminates a virtual machine , similar to a power off.
# xm reboot DomainName/ID		reboot a virtual machine, runs through the normal system shut down and start up process.
# xm shutdown DomainName/ID		shut down a virtual machine, runs a normal system shut down procedure.
# xm pause
# xm unpause
# xm save
# xm restore
# xm migrate

Resource management options
# xm mem-set
# xm vcpu-pin
# xm vcpu-set

use the xm vcpu-list to list virtualized CPU affinities:
# xm vcpu-list
Name                          ID  VCPUs   CPU State  Time(s)  CPU Affinity
Domain-0                       0    0      0    r--   708.9    any cpu
Domain-0                       0    1      1   -b-    572.1    any cpu
r5b2-mySQL01                  13    0      1   -b-     16.1    any cpu

use the xm sched-credit command to display scheduler parameters for a given domain:
# xm sched-credit -d 0
{'cap': 0, 'weight': 256}

# xm sched-credit -d 13
{'cap': 25, 'weight': 256}

Monitoring and troubleshooting options
# xm top
# xm dmesg
# xm info
# xm log
# xm uptime
# xm sysrq
# xm dump-core
# xm rename
# xm domid
# xm domname

xen networking, virtualised networking
# brctl show		displays all configured bridges

config dir: /etc/xen/
log dir: /var/log/xen
kernel infos: /proc/xen/


kvm dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# virsh list --all
# virsh start vm.example.com
# virsh shutdown vm.example.com				stop a virtual machine
# virsh destroy vm.example.com				stop immediately
# virsh undefine vm.example.com				delete a virtual machine
# virsh reboot vm.example.com
# virsh dominfo vm.example.com				display configuration information



background foreground, process dinge, prozess dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
put running job in the background
Ctrl+Z
# bg		put stopped process to the background and run it there
# jobs		see running jobs
# fg		bring job to front


nohup
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# nohup bin/runProgram.sh 1>/var/log/out.log 2>/var/log/err.log &


/dev/shm
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
entry in /etc/fstab:
/dev/shm tmpfs size=2500m 0 0


gnuplot
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
using gnuplot to visualize iostat output:
# gnuplot
gnuplot> set xdata time
gnuplot> set xlabel "<anyLabel>"
gnuplot> set ylabel "<anyLabel>"
gnuplot> set y2label "<anyLabel>"
gnuplot> set grid
gnuplot> set ytics nomirror
gnuplot> set y2range [0:100]
gnuplot> set y2tics 0,20
gnuplot> plot "<filname>" using 0:3 title "read (kb/sec)" axis x1y1 with lines, \\
gnuplot> "<filname>" using 0:4 title "write (kb/sec)" axis x1y1 with lines, \\
gnuplot> "<filname>" using 0:9 title "%w" axis x1y2 smooth bezier, \\			# smooth bezier: line from dot to dot not from 0 to dot
gnuplot> "<filname>" using 0:10 title "%b" axis x1y2 smooth bezier

to make gnuplot generating an output file:
gnuplot> set term png
gnuplot> set output "iostat.png"
gnuplot> replot


# crontab, cron dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export EDITOR=vi
crontab -e			# edit the crontab
crontab -l			# list crontab entries

# crontab file for user root: /var/spool/cron/root

# date in crontab
0 5 * * 3 /data/script.sh > /data/script_`date +\%y\%m\%d`.log 2>&1	% signs has to be escaped by \

# redirect output in crontab
# do not use &> as redirect, it will not work, use > instead

# make sure every line in crontab ends with a newline!


# proc/sys filesystem
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mount -t proc none /proc			# creates a /proc fs in a chroot environment for example
mount -t sysfs sysfs /sys			# not yet verified (may also try: mount -t sysfs none /sys)


# chroot
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
chroot /dir/to/have/as/root bash --login


# hp smart array, HP SmartArray
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# hpacucli is part of the HP ProLiant Support pack which is available at hp support site.
hpacucli controller all show status
hpacucli controller slot=1 show config detail		# display detail configuration on controller in slot 1

# SMART disktest utility with HP smartarray controller (RHEL5)
smartctl -i -d cciss,0 /dev/cciss/c0d0		# cciss,1 would be the second disk
smartctl --test=long -d cciss,0 /dev/cciss/c0d0


kdump dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RHEL 5 # yum install --enablerepo=rhel-debuginfo crash kernel-debuginfo
RHEL 6 # yum install crash debuginfo-install kernel
# vi /boot/grub/grub.conf
kernel ... crashkernel=128M
# vi /etc/kdump.conf
path /var/crash
core_collector makedumpfile -c --message-level 1 -d 31
# chkconfig kdump on
# reboot

test the configuration:
# echo 1 > /proc/sys/kernel/sysrq
# echo c > /proc/sysrq-trigger

find the crash dump in /var/crash for analyze
# crash /var/crash/timestamp/vmcore /usr/lib/debug/lib/modules/kernel/vmlinux


megacli
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LSI raid control utility
# megacli -AdpEventLog -GetEvents -f events.log -aALL && cat events.log		get the disk controller events
# /opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aALL				get all infos of LSI adapter
# /opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -Lall -aALL				list all logical volumes
# /opt/MegaRAID/MegaCli/MegaCli64 -CfgDsply -aALL				list all configurations (disk groups)

physical disk:
# /opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL					list all physical drives
# megacli -PDInfo -PhysDrv [<EnclosureDeviceID>:<SlotNumber>] -aAll		details on the specific disk (<EnclosureDeviceID>:<SlotNumber>)
# megacli -PDMakeGood -PhysDrv [252:0] -a0					change the state of a failed disk to "unconfigured-good"


hardening
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. separate partitions
	separate 'user' partitions: /home, /tmp, /var/tmp
	use specific mount options in /etc/fstab:
The 'defaults' option is equal to rw,suid,dev,exec,auto,nouser,async
Using noexec instead prevents execution of binaries on a file system (though it will not prevent scripts from running). 
Using nosuid will prevent the setuid bit from having effect. 
The nodev option prevents use of device files on the filesystem.

2. Software
	Install only required software. Uninstall all unneeded packeges.

3. OS update
	Keep the OS up to date:
yumupdate-sd is not reliable use a cron script instead:
/etc/cron.weekly/yum.cron:
#!/bin/sh
/usr/bin/yum -R 120 -e 0 -d 0 -y update yum
/usr/bin/yum -R 120 -e 0 -d 0 -y update

4. services
	stop all unneeded services. The following service can be safely disabled unless needed:
unneededServices="anacron haldaemon messagebus apmd hidd microcode_ctl autofs hplip pcscd avahi-daemon isdn readahead_early bluetooth kdump readahead_later cups kudzu rhnsd firstboot mcstrans setroubleshoot gpm mdmonitor xfs"

5. network
	check for listening ports
# netstat -tulpn		if unneeded ports are listening, disable apropriate services
	disable IPv6
/etc/sysconfig/network:
NETWORKING_IPV6=no
IPV6INIT=no
/etc/modprobe.conf:
install ipv6 /bin/true		reboot the server

6. configure firewall

7. enable TCP wrapper

8. enable SELinux
	/etc/selinux/config:
SELINUX=enforcing
SELINUXTYPE=targeted

9. kernelparameters
	/etc/sysctl.conf
# Turn on execshield
kernel.exec-shield=1
kernel.randomize_va_space=1
# Enable IP spoofing protection
net.ipv4.conf.all.rp_filter=1
# Disable IP source routing
net.ipv4.conf.all.accept_source_route=0
# Ignoring broadcasts request
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_messages=1
# Make sure spoofed packets get logged
net.ipv4.conf.all.log_martians = 1

10. files
	no files should be owned by nobody
# find / -xdev \( -nouser -o -nogroup \) -print
	no folders should be world writeable without sticky bit set
# find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print
	check for files with suid or sgid set
# find / -path -prune -o -type f -perm +6000 -ls
remove if possible the suid or sgid bit
# chmod -s <file>
unless otherwise required the following suid or sgid bits can be unset:
unneededSBits="/bin/ping6 /sbin/mount.nfs /sbin/mount.nfs4 /sbin/netreport /sbin/umount.nfs /sbin/umount.nfs4 /usr/bin/chage /usr/bin/chfn /usr/bin/chsh /usr/bin/crontab /usr/bin/lockfile /usr/bin/rcp /usr/bin/rlogin /usr/bin/rsh /usr/bin/wall /usr/bin/write /usr/bin/Xorg /usr/kerberos/bin/ksu /usr/libexec/openssh/ssh-keysign /usr/lib/vte/gnome-pty-helper /usr/sbin/ccreds_validate /usr/sbin/suexec /usr/sbin/userisdnctl /usr/sbin/usernetctl"

11. logging
	track systems activities using logwatch

12. intrusion detection
	check file integrity with AIDE


aide
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AIDE is an open source host-based intrusion detection system which is a replacement for the well-known Tripwire integrity checker. It provide software integrity checking and it can detect that intrusions (monitor filesystem for unauthorized change such as find out if system binaries modified and a new cracked versions installed or not) have occurred on the system.

# yum install aide
config file: /etc/aide.conf
# aide -i							initialize aide db (do this prior to take system online!)
# cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz	make a initial db copy
You need to move the database, as well as the configuration file /etc/aide.conf and the aide binary (/usr/sbin/aide) to a secure offsite readonly location. 
# scp /var/lib/aide/aide.db.new.gz /etc/aide.conf /usr/sbin/aide <user>@<offsiteServer>
test the installation
# touch /bin/date
# aide -C [-V100]	runs a check with verbosity level 100 (value between 0-255)


# open scap, security assessment, oscap dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# installation: look for openscap

# get a local report (verified on suse11sp3):
oscap oval eval --results ./firstTry.xml /usr/share/openscap/scap-oval.xml
oscap oval generate report --output firstTry.html ./firstTry.xml


# random dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo $RANDOM
od -vAn -N4 -tu4 < /dev/urandom		# sample output: 2494028411
od -An -N2 -i /dev/random			# sample output: 62362


# sar dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# configuration on suse:
zypper pa | grep sysstat		# check if sysstat is installed
zypper in sysstat				# if not, install
/etc/init.d/boot.sysstat		# start collecting daemon (sadc); reports available under /var/log/sa/saDD where DD is the actual day
cd /etc/cron.d
ln -s /etc/sysstat/sysstat.cron sysstat

# better cron entry than standard (/etc/cron.d/sysstat):
0 * * * * root /usr/lib64/sa/sa1 600 6 &	every 10min output with measurement for 10min
0 * * * * root /usr/lib64/sa/sa1 60 60 &	every 1min output with measurement for 1min

# cpu
sar [seconds] [iterations]
# memory
sar -r
sar -B				# paging

# disk
sar -d
sar -b				# I/O transfer rates
sar -q				# system load

# network
sar -n [keyword]			# where
	# DEV: Generates a statistic report for all network devices
	# EDEV: Generates an error statistics report for all network devices
	# NFS: Generates a statistic report for an NFS client
	# NFSD: Generates a statistic report for an NFS server
	# SOCK: Generates a statistic report on sockets
	# ALL: Generates all network statistic reports

sar -f /var/log/sa/saXX		# get the sar data from day XX
sar -f /var/adm/sa/saXX		# get the sar data from day XX on solaris


# usb dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lsmod | grep hci
	# ohci-hcd: USB 1.1
	# ehci-hcd: USB 2.0


systemd, systemd dinge, systemctl dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
config files:
	/usr/lib/systemd/system/
	/lib/systemd/system/

# systemctl <start/stop/restart/status/enable/disable> <service: zBsp. sshd.service>
# systemctl list-units				lists all available units
# systemctl list-units -t service	lists only the services
# systemctl list-units -t target	lists only the targets
# systemctl isolate reboot.target	"changes a runlevel" (runlevel = target)

get default target (runlevel)
	$ systemctl get-default
set default target (o. runlevel):
	# systemctl set-default <name of target>.target
	# ln -s /lib/systemd/system/graphical.target /etc/systemd/system/default.target

single user kernel parameter (at system boot)
	systemd.unit=rescue.target
	# systemctl rescue				single user with mounted fs
	# systemctl emergency			singel user only / mounted

	
chkconfig
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# chkconfig: 2345 55 25
put this in header of initscript: 2345: runlevels 55: startpriority (like S55<scriptname>) 25: kill priority (like K25<scriptname>)


nfs dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
edit /etc/exports. e.g.:
/dir	*(rw,sync,no_root_squash,no_subtree_check)
/dir2	host1(rw,sync,no_root_squash,no_subtree_check) host2(...)
# exportfs -a
# service nfs restart

server setup (on RHEL6):
# yum install nfs-utils
# service rpcbind start
# service rpcidmapd start
# service nfs start

on client:
# service portmap start
# mount -t nfs <server>:/dir
# chkconfig netfs on		if you want nfs to mount shares (in /etc/fstab) at boot time

# showmount -a <server>		prints all available dirs on server
# showmount -e <server>		prints exports file of server

# rpcinfo -p			check if nfs is running

making nfsd verbose
/etc/sysconfig/nfs edit:
RPCMOUNTDOPTS="-d all"
/etc/rsyslog.conf edit:
*.debug		/var/log/messages
and for rpc.nfsd:
# echo 1 > /proc/sys/sunrpc/nfs_debug

RMAN mount options for nfs (rman):
10.99.0.142:/vol/nfs_oracle_backup		/u04	nfs    rw,bg,hard,nointr,rsize=32768,wsize=32768,tcp,vers=3,timeo=600,actimeo=0 0 0

Error:
Starting NFS quotas: Cannot register service: RPC: Unable to receive; errno = Connection refused
Resolution:
# service portmap start
# service nfs start


# RHEL: cluster
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# tips creating cluster with conga (ricci & luci)
# - nodenames must be similar to $HOSTNAME (casesensitive!)
# - interconnect ip addresses must be registered in /etc/hosts associated to nodes $HOSTNAME
# error: cluster is not starting, hangs on fencing
# resolution: check interconnect network for multicast capabilities

# starting cluster
service cman start
service clvmd start		# if necessary
service gfs start		# if necessary
service rgmanager start

# stopping cluster
# same as starting cluster. last started services has to be stopped first.

# check cluster status
cman_tool status
group_tool
ccs_tool update /etc/cluster/cluster.conf	# updates a manually edited cluster.conf to all cluster members

# create quorum disk
fdisk /dev/mapper/qdisk				# create primary partition
kpartx -a /dev/mapper/qdisk			# present new device file to system
mkqdisk -c /dev/mapper/qdisk1 -l 	# quorum_disk
mkqdisk -L							# display infos about active quorum disks

# SCSI3-PR fencing
# 1. fence device über luci konfigueriert (s.d. cluster.conf)
# 2. multipathing Konfiguration angepasst (s.d. multipath.conf)
# 3. cluster lvm gestartet (auf beiden Nodes) und device konfiguriert (auf einem Node):
service clvmd start
chkconfig scsi_reserve on
pvcreate /dev/mapper/test
vgcreate vg_test /dev/mapper/test
lvcreate -l 100%FREE -n lv_test vg_test
gfs_mkfs -plock_nolock -j 1 /dev/vg_test/lv_test
mount /dev/vg_test/lv_test /mnt
service scsi_reserve start		# (auf allen Nodes)

# error:
# sd 1:0:1:14: reservation conflict
# SCSI error: return code = 0x00000018
# resolution: check on both nodes (!) with following command if a node holds reservation
sg_persist -d /dev/<sdDevice> -i -k
# clear reservation:
sg_persist -d /dev/<sdDevice> -o -G -K <key> -S 0

# Oracle as a failover clusterservice
# initscript: /usr/share/cluster/oracledb.sh


# boot, grub
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# make a copied /boot bootable
# start with livecd mount root device under /mnt/root and boot device under /mnt/boot
cp -a /mnt/root/boot /mnt/boot
umount /mnt/boot
mount <bootDevice> /mnt/root/boot
grub-install --root-directory=/mnt/root <bootDevice>
# check /mnt/root/etc/fstab for correct entries (may better use fs labels but devicenames)

error: <rootDevice> already mounted or sysroot busy
resolution: create a /proc and /sys dir on <rootDevice>


mondo
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
create system image iso
# mondoarchive -Oi -p $(hostname)_$(date +%d-%b-%Y)_sysImage.iso -I / -E "/mnt|/proc|/tmp" -d /tmp -N -0 -s 4400m
-Oi     create an ISO image
-p      name it sysBackup
-I      containing all files
-E      exclude the directories /mnt and /proc
-d      to the destination dir: /mnt/ftp
-N      exclude all mounted network filesystems
-0      use no compression (compression levels available 0-9)
-S      build the ISOs in the scratchdir /mnt/ftp/tmp
-T      use the tempdir /mnt/ftp/tmp
-s      make the ISOs not bigger than 650m

# mondoarchive -On nfs://192.168.235.1:/ftp -p jar -I / -E "/mnt|/proc" -N -0 -T /mnt/ftp/tmp -s 4400m
-On     create your backup on the NFS share 192.168.235.1:/ftp
-p      use file prefix jar
-I      containing all files
-E      exclude the directories /mnt and /proc
-N      exclude all mounted network filesystems
-0      use no compression (compression levels available 0-9)
-T      use the tempdir /mnt/ftp/tmp
-s      make the ISOs not bigger than 4400m


# syslog, journalctl dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logger <text which should be written to syslog>

# in systemd environments:
	systemd-analyze					# the boot process duration
	systemd-analyze blame			# in more details
	journalctl -b					# all the events since the last boot
	journalctl --since=today		# all the events that appeared today in the journal
	journalctl -p err				# all the events with a syslog priority of err
	journalctl -f					# the 10 last events and wait for any new one (like tail -f /var/log/messages)



# loop, create file as a raw device, disk file 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dd if=/dev/zero of=/asm/disk1 bs=1024 count=2097152		# creates a 2gb file
losetup /dev/loop1 /asm/disk1							# losetup is used to associate loop devices with regular files or block devices
# now the disk is usable for LVM for example
	raw /dev/raw/raw1 /dev/loop1 							associate the character block device with a raw block device

# thin provisioning
	dd of=disk1 bs=1 count=0 seek=20G
	ls -alhs .
	0 -rw-r--r--   1 root root  20G May 15 13:18 disk1


# telnet, escape character is '^]'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
<AltGr> + <Ctrl> + 9
MacBook: <Shift> + <Alt> + 2


# keyboard, layout
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cat /etc/sysconfig/keyboard 
KEYTABLE="sg-latin1"
MODEL="pc105"
LAYOUT="ch"
KEYBOARDTYPE="pc"
VARIANT="de_nodeadkeys"

# change layout
loadkeys -d
cd /usr/share/keymaps/i386/qwerty
mv defkeymap.kmap.gz not_my_defkeymap.kmap.gz
cd ../qwertz
ln -s sg-latin1.kmap.gz defkeymap.kmap.gz
loadkeys -d

# calculator, bc
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bc
	ibase=2		# input base
	obase=16	# output base; calculates hex values
	obase=A		# output base; calculates decimal values
	quit		# ends bc
echo 'ibase=16;obase=A;FF' | bc		# prints the decimal value of FF


installed hardware infos, devinfo, devices, pci, cpu, memory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Including device - driver mapping
# dmidecode | egrep -i 'cpu|core'	lists infos on CPU and cores count
# dmidecode -t system			lists only the most relevant system infos
# lspci -nnk [-v]
# lshal
# lsusb
# dmidecocde
# lshw			Debian (Ubuntu) only


sudo dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
allow script execution on a directory with sudo (/etc/sudoers):
	User_Alias USERS = bob, bill
	Cmnd_Alias COMMANDS_A = /path/to/dir/, /path/to/script.sh
	Cmnd_Alias COMMANDS_B = /path/to/another/script.sh, /usr/bin/less /var/log/messages
	USERS ALL = NOPASSWD: COMMANDS_A,COMMANDS_B
	oracle    		ALL=NOPASSWD:/usr/sbin/clustat			# command clustat for user oracle on all machines without a password
	%local_root     ALL=(root:root) NOPASSWD: ALL			# all root commands on all machines without password


gpg, pgp, openpgp, key, gpg dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ gpg -d <messageFile>				include -----BEGIN PGP MESSAGE----- and -----END PGP MESSAGE----- in the <messageFile>
$ gpg --clearsign <messageFile>		signs a message which is still readable unencrypted (digital signature)
$ gpg -e <messageFile>				encrypts a message, you will be prompted for receipient
$ gpg --search-keys <searchString>
$ gpg -k							lists all imported public keys
$ gpg --fingerprint					display my gpg fingerprint (e.g. to get the id)
$ gpg --export -a "<id>" > frc.txt	exports the public key of <id>
gpg --armor --export <id>		export public key


snmp
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
UDP Port 161
/etc/snmp/snmp.conf
# service snmpd status
# snmpstatus -c public -v 1 localhost
# snmpget -c public localhost system.sysDescr.0

get rid of errors like "Received SNMP packets from UDP: 127.0.0.1:xxxx" in syslog
/etc/sysconfig/snmpd.options	(remove the -a)
OPTIONS=¿-Lsd -Lf /dev/null -p /var/run/snmpd.pid¿

get rid of errors like "Connection from UDP: [127.0.0.1]:xxxxx" in syslog
/etc/snmp/snmpd.conf
dontLogTCPWrappersConnects true


direct message
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# who
# echo 'Hallo Freund' | write <user> pts/2
broadcast a message to all users
# echo 'Hallo Welt' | wall


df, filesystem type, fstyp, filesystem dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# df -n
# df -T			display file system type
# df -o i		displays free inodes
# dumpe2fs <device>	get filesystem superblock infos of <device>


udev dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
config: /etc/udev/udev.conf
reread udev rules and execute actions without rebooting the server
# udevtrigger		or
# udevadm trigger

get infos from a device
# udevinfo -a -p <sysfs-device>
# udevinfo -a -p /sys/class/net/eth0

udev rule to set device file name (this will not work with a partitioned device! udev will not create device files for the partitions)
KERNEL=="sd*", BUS=="scsi", PROGRAM=="/sbin/scsi_id -g -u -s %p", RESULT=="3600a0b8000266c0a000015c54e9b9b5c", NAME="backup-ora", ACTION=="add|change"
check RESULT with: 
# /sbin/scsi_id -g -u -s /block/sdX
test rule with:
# udevtest /block/sdX

udev rule to change device file permissions and set its name
KERNEL=="sd*", BUS=="scsi", PROGRAM=="/sbin/scsi_id -g -u -s %p", RESULT=="3600a0b8000266bf000002f694e671cb3", NAME="ora-lun48", ACTION=="add|change", OWNER="grid", GROUP="asmadmin", MODE="0660"

tested on OL6.4 x64:
KERNEL=="sd?1", BUS=="scsi", PROGRAM=="/sbin/scsi_id -g -u -d /dev/$parent", RESULT=="1IET_00010001", NAME="ocr", OWNER="oracle", GROUP="dba", MODE="0660"

udev rule to change network interface device name (tested on OL5.7, OVM3.1)
KERNEL=="eth*", SYSFS{address}=="78:e3:b5:f4:77:b8", NAME="eth10", ACTION=="add|change"


device handling, major minor number
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
major number:	class of device, tells the kernel what king of device it is
minor number:	identifies the instance of the device in the class
# man major

find appropriate block device for char (raw) device
# raw -qa	lists minor numbers of used block devices


modules
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/modprobe.conf

prevent modules from being loaded (add to modprobe.conf):
blacklist <moduleName>
install <moduleName> /bin/true


RDAC, rdac, ibm multipath driver installation & handling
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
install kernel headers and source (kernel-header, kernel-devel) and see if Makefile search on the correct location.
otherwise adjust with the correct softlink (sources should be in /usr/src/kernels)
install as described in Readme.txt but be patient especially if many LUNs are connected! (mkinitrd takes time)
# mppUtil -a		Subsystem details
# mppUtil -a <name>     Subsystem <name> details
# mppUtil -S		Connected devices
# ls -lR /proc/mpp/	list LUNs
# /opt/mpp/lsvdev	list LUN - device mapping
download the IBM Storage Manager single (e.g. SM10.77_Linux_64bit_x86-64_single-10.77.x5.16.tgz)
extract and install the two rpms:
# yum install --nogpgcheck Linux_x86-64/SMutil-LINUX-10.00.A5.19-1.x86_64.rpm Linux_x86-64/SMruntime-LINUX-10.77.A5.03-1.x86_64.rpm
# SMdevices		list the LUNs with their appropriate device file
# mppBusRescan		rescan for new devices

configuring system to log at serial console (com)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
edit /boot/grub/grub.conf
	serial --unit=1 --speed=19200		-> unit=1 is the first com port; 2 is the second
	terminal --timeout=8 console serial
disable the splashimage file
	#splashimage=(hd0,0)/grub/splash.xpm.gz
append the followin to the 'kernel' line
	console=tty0 console=ttyS0,19200n8	-> if serial console is not available display (tty0) will be used
						-> ttyS0 is the first com port, ttyS1 the second
edit the /etc/inittab and add following line
	1:23:respawn:/sbin/agetty -h -L ttyS0 19200 vt100



display current runlevel
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# who -r


# create ramdisk
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# make sure mountpoint /mnt/ramdisk exists
mount -t tmpfs none /mnt/ramdisk -o size=5048m


# sed dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sed 's/<searchPattern>/<replaceString>/' -i <file>		# -> use \ to handle special chars in search or replace string
sed -i 's,searchPattern,'"$variable"',' <file>
sed -i 's@^image:.*@    image: '"$var"'@' file			# replace whole line starting with image:
sed "/<searchPattern>/d" -i <file>						# removes the line with <searchPattern>
sed -i '1 d' <file>										# removes the first line of <file>
sed -i '$ d' <file>										# removes the last line of <file>
sed -i '/<searchPattern>/a Hello World' <file>			# append "Hello World" after <searchpattern>
echo " test test test " | tr -d ' '						# removes all white spaces
echo " test test test " | sed 's/ *$//g'				# removes trailing white spaces
echo " test test test " | sed 's/^ *//g'				# removes leading white spaces
echo " test test test " | sed 's/^[ \t]*//;s/[ \t]*$//'	# removes both (leading & trailing) white spaces

solaris:
# perl -pi -e 's/who/when/g' /tmp/afile

osx:
# sed -i '' -e '1 d' <file>			removes the first line of <file>
# sed -i '' -e '$ d' <file>			removes the last line of <file>


# set the backspace key
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
stty erase <pressTheBackspaceKey>


# remove line breaks, linebreaks, line feeds, tr dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tr -d '\015' < inputFile > outputFile				input and output File should not be the same!!
tr '[:upper:]' '[:lower:]' < input.txt > output.txt		converts all uppercase letters to lower case letters


# get UUID, uuid 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
blkid					# prints a list of all used UUIDs


# mount dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mount options for NFS mounts (fstab entry):
<nfsServer>:<nfsShare>		<mount>	nfs    rw,bg,hard,nointr,rsize=32768,wsize=32768,tcp,vers=3,timeo=600,actimeo=0,noac,nolock	0 0

# read only filesystem in maintenance mode (e.g. fstab with wrong entry)
# on repair filesystem:
mount -o remount,rw /


# san, lun, multipathing stuff, hba, multipath dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RHEL6: use mpathconf utility to setup and configure multipathd!
mpathconf

# Adding new LUN to system without rebooting
# find system WWNN wwn
	less /sys/class/fc_transport/*/node_name
	cat /sys/class/scsi_host/host0/device/fc_host:host0/port_name

# find HBA number, channel and SCSI target (where 5001438004c8a250 is your WWNN
	grep 5001438004c8a250 /sys/class/fc_transport/*/node_name
/sys/class/fc_transport/target2:0:0/node_name:0x5001438004c8a250
/sys/class/fc_transport/target2:0:1/node_name:0x5001438004c8a250
/sys/class/fc_transport/target3:0:0/node_name:0x5001438004c8a250
/sys/class/fc_transport/target3:0:1/node_name:0x5001438004c8a250

# another possibility is to use the multipath command (only if luns are already installed)
mpath12 (3600143800648ef6200004000006f0000) dm-12 HP,HSV300
[size=40G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:1:7 sdz  65:144 [active][undef]
	2 = HBAnumber 	(hostX)
	0 = channel	("x 0 7")
	1 = target	("0 x 7")
	7 = lun		("0 0 x")
# echo the following commands:
	echo "0 0 7" > /sys/class/scsi_host/host2/scan
	echo "0 1 7" > /sys/class/scsi_host/host2/scan
	echo "0 0 7" > /sys/class/scsi_host/host3/scan
	echo "0 1 7" > /sys/class/scsi_host/host3/scan

# Removing multipath LUN online (RHEL5)
multipath -ll mpath12
for i in `multipath -ll mpath12 | grep sd | awk '{print $3}'`; do blockdev --flushbufs /dev/$i; done
for i in `multipath -ll mpath12 | grep sd | awk '{print $3}'`; do echo 1 > /sys/block/$i/device/delete; done
multipathd -k'remove map mpath12'	<- if this is not working try following commands
dmsetup remove /dev/dm-12
# device-mapper: remove ioctl failed: Device or resource busy
# Command failed
dmsetup remove -f /dev/dm-12

# Removing multipath LUN online (RHEL6)
multiapth -f <mpathDevice>

# Resize LUN online
# I made bad expirience so its better to test prior to resize a lun on a productive system!
multipath -ll mpath12
for i in `multipath -ll mpath12 | grep sd | awk '{print $3}'`; do echo 1 > /sys/block/$i/device/rescan; done
multipathd -k'resize map mpath12'
resize2fs /dev/mapper/mpath12				# <- only if its a unpartitioned and no lvm volume. otherwise use apropriate commands first

# configure multipathing with dm-multipathing on RHEL6
mpathconf --enable --with_multipathd y
mpathconf									# check multipathing settings
multipath -v3								# get detailed infos
/etc/multipath/bindings						# define bindings here
service multipathd reload					# reload /etc/multipath.conf	(works online, tested on OL6.3)


# qlogic hba
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scli		# -> SANsurfer utility
# disable hba failover mode in /etc/modprobe.conf
options qla2xxx ql2xfailover=0

# data transfer size, i/o size, tsize parameter setting
# this is done at runtime (not a modprobe parameter). add the following to /etc/rc.d/rc.local
echo 128 > /sys/block/<device>/queue/max_sectors_kb

# to change max_sectors_kb on multipath managed disks use script in ressources/scripts/setEVAparams.sh

# rescan SCSI, scsi bus online; search for new attached scsi disk
echo "- - -" > /sys/class/scsi_host/host0/scan

# RHEL6 (needs sg3_utils package):
rescan-scsi-bus.sh
lsscsi


# emulex hba
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# hbanyware commands:
/usr/sbin/hbanyware/hbacmd listhbas
/usr/sbin/hbanyware/hbacmd GetDriverParams <portWWN>


# hdlm, hitachi, hds
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
chkconfig --list boot.hdlm				# hdlm startup service
service DLMManager status
# location for scripts: /etc/sysconfig/hdlm-scripts

dlmcfgmgr -r							# reconfiguring HDLM device configuration
dlmcfgmgr -v							# display HDLM device configuration

/opt/DynamicLinkManager/bin/dlnkmgr help						# display help screen
/opt/DynamicLinkManager/bin/dlnkmgr <function> -help			# display help screen for <function>
/opt/DynamicLinkManager/bin/dlnkmgr view -path [-hbaportwwn]	# displays all path
/opt/DynamicLinkManager/bin/dlnkmgr view -lu					# displays all LUNs (logical)
/opt/DynamicLinkManager/bin/dlnkmgr view -drv					# displays all drives (physical)
/opt/DynamicLinkManager/bin/dlnkmgr view -sys					# displays details on HDLM driver environment

# ERRORS:
FATAL: Module sddlmadrv not found.
FATAL: Module sddlmfdrv not found.
	# /boot must be mounted prior to hdlm installation!


# Performance testing network
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# tool: netperf	http://www.netperf.org/
# take version 2.x instead of 4.x because of the fewer prerequisites
# build and install the tool as usual
netserver							# starts the netserver process
netperf -P1 -l 30 -H <IP-Address>	# starts a test for 30 sec on interface with the address <IP-Address>

# tool: iperf	http://iperf.sourceforge.net/ 
iperf -s --bind 10.99.0.45			# starts the iperf server
iperf -i 2 -t 120 -d -c ora1		# starts the client


# initrd dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# check content of initrd
zcat initrd.img | cpio -itv | grep <whatever>
# extracting initrd
mkdir initrdroot; cd initrdroot
gzip -dc ../initrd.img | cpio -id
# compressing initrd
find ./ | cpio -H newc -o >../initrd.img.new
gzip ../initrd.img.new

# adding driver to initrd.img
file initrd.img
# it is a gzipped archive!
gunzip < initrd.img > initrd.img.unzipped
file initrd.img.unzipped
# it is a cpio file
mkdir a
cd a
cpio -dumi < ../initrd.img.unzipped
cd modules
file modules.cgz
# it is a gzipped archive!
mv modules.cgz modules.cgz.gz
gunzip modules.cgz.gz
cpio -i --verbose --make-directories < modules.cgz
cp /tmp/e1000e.ko 2.6.18-194.el5/x86_64/
find 2.6.18-194.el5 | cpio -ovF modules.cgz
gzip modules.cgz
mv modules.cgz.gz modules.cgz
rm -rf 2.6.18-194.el5
sync
cd ..
mv ../initrd.img ../initrd.img.old
find . | cpio -H newc -ov | gzip -9 -c - > ../initrd.img


# dataprotector and tcp wrapper config
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# configure TCP Wrapper to allow DataProtector:
# add following line to /etc/hosts.allow
inet:<serverNameFullQualified> or <subnetInNotation: xxx.xxx.xxx.>

# Dataprotector config files:
/etc/opt/omni/client/

# check for a daemon whether it is compiled with tcp wrapper
ldd /path/to/binary | grep libwrap.so


# dd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# create big file, large file
dd if=/dev/zero of=big_file bs=1MB count=1000		# creates a 1GB file
# watch dd progress
kill -USR1 <pidDDprocess>


# bzip2 dinge, zip dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bzip2 <fileToCompress>
bzip2 -d <archiveToDecompress>
bunzip2 file.bz2
# compress dir using zip
zip -r <zip-archive> <dir-to-zip>


# tar dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# !! if possible use relative path in tar commands !!
# Create a new set of backup
	tar pcvf <archive.tar> file1 file2 dir1 dir2 file2 
		# * c  Create a new files on tape/archive
		# * v  verbose i.e. show list of files while backing up
		# * f  tape device name or file
		# * p  keeps permissions and dates
#Extract from tar file
	tar xvf /path/to/tarfile						# extracts complete tarfile
	tar xvf /path/to/tarfile --wildcards "data/*"	# extracts only content of /data
	tar xvf archive.tar -C /target/directory		# extract to another dir then the location of the archive
# List content of tar file
	tar tvf /path/to/tarfile

# find & tar
	find . -type f -name "*.java" | xargs tar rvf myfile.tar

# using tar in combination with zip and keep selinux context
	tar --selinux -czvf directory.tgz directory			# create gzipped tar archive
	tar --selinux -xzvf directory.tgz					# uncompress
	tar --selinux -cjvf directory.tgz directory			# create bzipped2 tar archive
	tar --selinux -xjvf directory.tgz					# uncompress

# using star (standard tape archiver)
# compress, keeping selinux context
	star -xattr -H=exustar -c -f=directory.star directory
# decompress
	star -x -f=directory.star
	
	
compilieren, build von Software
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Errors beim ./configure bedeuten i.d.R., dass gewisse Libraries oder Headers nicht gefunden werden.
Es muss also herausgefunden werden, wo die benötigten Libraries liegen und dann mit folgendem Befehl dem Suchpfad des configure Scripts hinzugefügt werden.
FreeBSD:	#  env LDFLAGS=-L<pfad/zur/library> CPPFLAGS=-I<pfad/zum/include> ./configure
		#  env LDFLAGS=-L/usr/local/lib/db47/ CPPFLAGS=-I/usr/local/include/db47/ ./configure


# find dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
find <ort> -name "<filename>" -type f
find / -name "core" -type f
find / -ctime -1										# change time not older than 1 day
find / -atime -1 ! -name test.*							# access time not older than 1 day and filename not like test.*
find / -mtime -1										# modified time not older than 1 day
find / -mtime +1 -exec ls -lrt {} +;					# modified time older than 1 day and sort them by date
find / -type f -perm -o+w -exec ls -l {} \;				# find all files with world write permission
find . -name "*.repo" -exec mv {} {}.disabled \;		# find all .repo files and mv them to *.repo.disabled
find / \( -perm -4000 -o -perm -2000 \) -print			# find all files with suid or sgid bit set
find / -path -prune -o -type f -perm +6000 -ls			# find all files with suid or sgid bit set
find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print	# find world writable folders without sticky bit set
find / -type f -size +5M -printf "%s:%h%f\n"			# find files bigger than 5MB
find /etc -type f | xargs grep -in "<searchString>"		# find in files
find . -xdev -inum <number>								# find the file at inode number <number>
find /var -type f | xargs stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head		# lists the 10 last modified files under /var
find / -perm -u+s -not -path "/proc/*"					# find all SUID files excluded the /proc dir from search
find /var/ -type f -name "*log*" | xargs -i cp "{}" /tmp/chrigi/	# copy all "log" files in /var to /tmp/chrigi


# history
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!<number>		repeats command <number>
# clear history:
rm -f ~/.bash_history
history -c


# Distribution, Info, Kernel, Version
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
uname -a
cat /etc/issue


# Services Status
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RHEL:
service --status-all
service <servicename> status
netstat -tulpn					# zeigt Services mit ihren offenen Ports


# Speicher, Storage, Disk Devices anzeigen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fdisk -l | grep /dev/sd*

# log, messages, system events Uebersicht
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
multitail


# Maus, Mouse in der Konsole starten
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
service gpm start


# iso dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mount iso
mount dvd.iso /path/to -o loop

# /etc/fstab entry:
/repo/iso/beispiel.iso    /mnt/iso   iso9660   loop,ro 0 0

# create iso image from cd-rom
dd if=/dev/cdrom of=/tmp/cdimg1.iso
# create iso image from files
mkisofs -r -o <isoName>.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -R -J -v -V "TEST BOOT" -A "TEST BOOT" <folder>


# iptables dinge, firewall dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
iptables -L						# lists all configured rules
iptables -vL -n --line-numbers				# lists all configured rules with interface and numeric ports
service iptables status					# displays the rules numbers
iptables <actionsParameter> <chain> <ruleDetails>
iptables -P INPUT DROP					# default action for INPUT
iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP		# drops all ping packets from 127.0.0.1	

# use at the end of chain to log all dropped packets (max 15 entrys per minute):
iptables -A INPUT -m limit --limit 15/minute -j LOG --log-level 7 --log-prefix "iptables drop: "
# add following lines to /etc/rsyslog.conf
:msg, contains, "iptables"                              /var/log/iptables.log
:msg, contains, "iptables"                              ~

iptables -D <chain> <ruleNumber>						# deletes a rule
# rules will be deleted at server stop
# RHEL:	
service iptables save									# saves rules in /etc/sysconfig/iptables

# iptables as NAT router:
# do not forget to set "net.ipv4.ip_forward = 1" in /etc/sysctl.conf
iptables -t nat -A POSTROUTING -o <internetInterface> -j MASQUERADE
iptables -A FORWARD -s 192.168.55.0/24 -j ACCEPT
iptables -A FORWARD -d 192.168.55.0/24 -j ACCEPT
iptables -A FORWARD ! -s 192.168.55.0/24 -j DROP

# RHEL7, firewall-cmd
# firewalld conf file:  /etc/firewalld/firewalld.conf
# zones: defines the trusted level for the attached network
systemctl <start/stop/status> firewalld	

# Infos auslesen:
firewall-cmd --list-all				# zeigt alle Infos zur default Zone
firewall-cmd --list-all-zones		# zeigt alle Infos zu allen Zonen
firewall-cmd --get-services			# zeigt alle vorkonfigurierten Services an

# Einen Port oeffnen:
# oeffnet den Port 2049 (nfs) fuer die default Zone [oder fuer die Zone "public"]; --permanent: die Anpassung ist persistent
firewall-cmd --add-service=nfs [--zone=public] [--permanent]
# oeffnet 5900 (vnc) auf der default Zone
firewall-cmd --add-port=5900/tcp [--permanent]

# Einen Port schliessen:
# schliesst den Port 2049 (nfs) fuer die default Zone [oder fuer die Zone "public"]; --permanent: die Anpassung ist persistent
firewall-cmd --remove-service=nfs [--zone=public] [--permanent]
# schliesst 5900 (vnc) auf der default Zone
firewall-cmd --remove-port=5900/tcp [--permanent]
																		
# Anpassungen anwenden:
firewall-cmd --reload	


selinux dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
config: /etc/selinux/config
log: /var/log/audit/audit.log	(with auditd, if its not running check /var/log/messages instead)
	messages are labeled with 'AVC'
	create human readable format:
	# sealert -a /var/log/audit/audit.log > /path/to/mylogfile.txt

# sestatus								displays selinux status
# semodule -l								lists loaded modules
# ls -Z	<file>								displays security context for <file>
	user:role:type:mls ('mls' may is hidden; most important is 'type')
# chcon [-Rv] --type=<securityContextType> /html			change the security context
to make changes available through filesystem relabeling operations:
# semanage fcontext -a -t <securityContextType> "/html(/.*)?"		sets 'type' to <securityContextType> for /html and /html/*
# restorecon [-Rv] [-n] /html						restores default security context for dir /html; -n just try, do nothing
# semanage port -a -t http_port_t -p tcp 81				sets a different port for apache
# semanage port -l							displays all availble ports

# ps fauZ <process>				displays security context for <process>

create own modules (example with smtpd; not verified)
# grep smtpd_t /var/log/audit/audit.log | audit2allow -m postgreylocal > postgreylocal.te
# semodule -i postgreylocal

relabel filesystem
# touch /.autorelabel
# reboot

errors:
error while starting network: arping: error while loading shared libraries: libresolv.so.2
resolution: selinux filesystem relabeling required
# touch /.autorelabel
# reboot

error while executing relabeling (e.g. with command fixfiles relabeling): /etc/selinux/targeted/contexts/files/file_contexts.homedirs:  line 21 has invalid context user_u:object_r:user_mozilla_home_t:s0
resolution:
# genhomedircon
# touch /.autorelabel
# reboot


# nmap, Portscan, scanner
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nmap -T4 -A -v <host>		# intense scan
nmap -T4 -F <host>		# quick scan
nmap <host>			# regular scan


# vi dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:r! <command>		# schreibt den output von <command> nach dem cursor
:r! echo %:p		# insert the full file of current file
:r! echo %			# insert the current filename
:%s/OLD/NEW/g		# sucht nach OLD und ersetzt OLD durch NEW (search and replace)
:set number			# Zeilennummern anzeigen
:syntax on|off		# syntax highlighting
:set paste			# auto indent off, zum einfuegen von Code
:set nopaste		# auto indent on
Ndd					# Loescht N Zeilen von der aktuellen weg
D					# delete characters from cursor to end of line
J					# Join 2 lines (deletes linebrake, carriage returns)
I					# Insert at beginning of the line
^					# jump to the beginning of the line
Ctrl + F			# page down
Ctrl + B			# page up
0					# beginning of the line


# wget dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# download content of a webdir (avoid download of index.html)
wget -r --no-parent --reject "index.html*" http://site.com/dirToDownload
wget --no-check-certificate		# ignore SSL errors


# ssl dinge, certificates, cert dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
openssl x509 -text -in /path/to/cert.pem						# Read the certifiate
echo | openssl s_client -connect HOST:PORT 2>/dev/null | openssl x509 -text		# get the servers certificate full info
echo | openssl s_client -connect HOST:PORT 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > cert.pem	# save cert in .pem
openssl x509 -text -noout -in <(echo | openssl s_client -connect HOST:PORT 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p') # read cert
openssl verify [-CAfile internal-ca.pem] /etc/pki/tls/certs/<hostname>.pem			# verify cert
openssl s_client -connect <hostname>:<port>					# test connection
openssl pkcs12 -in <user>-cert.p12 -out <user>-key.pem -nocerts -nodes	# extract key to .pem format
openssl pkcs12 -in <user>-cert.p12 -out <user>-crt.pem -clcerts -nokeys	# extract cert to .pem format
awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cert.crt		 	# generate a one-line string from a certificate

# import SSL cert into default Java keystore
keytool -importcert -noprompt -file server.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -deststorepass changeit -alias "anyAlias"

# create private key
openssl genrsa -out $(hostname).key 4096

# create CSR
openssl req -new -key $(hostname).key -out $(hostname).csr -subj "/C=CH/ST=ZH/L=Zurich/CN=$(hostname -f)"


# Packet, rpm handling, rpm dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rpm -qip <rpmPacket>					# Infos über eine RPM Packet auslesen
rpm -ql <rpmPacket>						# displays all files of rpm packet
rpm -qd <rpmPacket>						# displays doc files of rpm packet
rpm -qc <rpmPacket>						# displays config files of rpm packet
rpm -q --scripts <rpmPacket>			# displays %pre, %post, %preun and %postun scripts
rpm -qpR <rpmPacket>					# Abhängigkeiten (Requires) anzeigen
rpm2cpio <rpmPacket> | cpio -idmv		# Entpackt die Daten aus einem rpm
rpm -qa --filesbypkg 					# lists all files in all packages

# create RPM:
yum install -y rpm-build rpm-sign
rpmbuild %{name}-%{version}.spec							# rpmbuild creates directory structure
cp %{name}-%{version}-devel.tar.gz ~/rpmbuild/SOURCES		# bring sources in place
vim ~/rpmbuild/SPECS/%{name}-%{version}.spec				# create a spec file
cd ~/rpmbuild/BUILD											# go to the BUILD dir
rpmbuild -ba ../SPECS/%{name}-%{version}.spec				# build a binary and source (-ba) rpm
rpm --resign %{name}-%{version}.rpm							# sign with a GPG key


RHEL Satellite, satellite, satellite dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
load RPMs into a custom channel:
	The satellite-sync command is used with RHN packages.
	The rhnpush command is used for private packages.
	# yum install -y rhnpush
	# vi /etc/sysconfig/rhn/rhnpushrc
	# diff rhnpushrc.bak rhnpushrc
		56c56
		< server                        =       https://localhost/APP
		---
		> server                        =       https://rhel-satellite.lotr.lab/
	$ rhnpush -c umb-test-channel -u chrigi test-1.0/test-1.0-2.el7.noarch.rpm		# upload one package
	$ rhnpush -d . -c umb-rhel-x86_64-server-7.0_custom -u chrigi -v				# upload all packages in current dir

registering a client at a satellite 6
	# yum -y --nogpgcheck install http://rhel-sat6.lotr.lab/pub/katello-ca-consumer-latest.noarch.rpm
	# subscription-manager register --org="umb" --activationkey="RHEL7-general"

registering a client at a satellite 5
	install the satellites SSL certificate on the client
	# wget http://rhel-satellite.lotr.lab/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
	# yum localinstall rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
	
	# vi /etc/sysconfig/rhn/up2date
	# diff up2date.bak up2date
		11c11
		< serverURL=https://enter.your.server.url.here/XMLRPC
		---
		> serverURL=https://rhel-satellite.lotr.lab/XMLRPC
	# rhn_register

config management
	$ rhn-actions-control --report				# list config mngmt settings on client
	# rhn-actions-control --enable-feature	
	# rhn-actions-control --disable-feature
	# rhncfg-client verify						# verifies the local config against the Satellite config
	# rhncfg-client list						# lists the configfiles managed by Satellite
	

# grep, OR verknüpft suchen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
less <file> | grep "<wort1>\|<wort2>"
less <file> | grep -E 'wort1|wort2'		# RegEx with grep
# show config file without comments
grep -v '#' /path/to/configfile


# bash dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# color prompt:
# in ~/.bashrc
PS1='[\[\033[1;31m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\] \A \W]\$ '

# if scp has problems copiyng files, may your .bashrc has some special chars. Use the following on top of .bashrc to skip .bashrc if not interactive:
[[ $- == *i* ]] || return

# clear history
history -c
reset


# bash loops, schleifen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for X in a b c; do echo $X; done
for ((i=0;i<10;i++)); do echo $i; done
read file liny by line: cat <file> | while read LINE; do echo $LINE; done

# DHCP Server (RHEL)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/dhcpd.conf
/var/lib/dhcpd/dhcpd.leases


# Nameserver, DNS, Domain, dns dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/resolv.conf

# set timeout:
option timeout:1
option attempts:1


chrony, chronyd, chronyc, chrony dinge, time
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
config file:	/etc/chrony.conf
	server 0.ch.pool.ntp.org iburst

# chronyc sources			analog ntp peers	


ntp, time, ntp dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ntpdc
ntpdc> peers				Zeigt die verfügbaren TimeServer
# ntpq -p [-n]				lists all peers; -n displays ips instead of names
# ntpq -p <ntpServer>			check status of <ntpServer>
# ntpdate -b <timeServer>		resets time to <timeServer> time immediately
# date -s "mm/dd/yyyy 13:23:00"

ntp server config (with restrictions):
restrict default ignore
restrict -6 default ignore
restrict 127.0.0.1
restrict -6 ::1
restrict 10.2.0.0 mask 255.255.0.0 nomodify notrap nopeer
restrict 192.168.0.1 nomodify notrap nopeer
server ntp1.ntp.com
restrict ntp1.ntp.com nomodify notrap nopeer
driftfile /var/lib/ntp/drift
keys /etc/ntp/keys

start ntp server in debug mode:
add "-d" in /etc/sysconfig/ntpd optionlist

if changes had been applied to /etc/ntp.conf test after synchronization messages in /var/log/messages appears


# date dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
date "+%s"						# Unix time in seconds
date "+%d-%m-%Y"				# 12-07-2012
date "+%d-%b-%Y"				# 12-Jul-2012
date "+%H:%M:%S"				# 09:00:08
date --date="yesterday"			# prints the date of yesterday
date -s "mm/dd/yyyy 13:23:00"
date -s <ntpServer>
date --date="@<timeInSec>"		# converts Number of Sec since 1.1.1970 into real date

# set timezone
/etc/sysconfig/clock
/etc/localtime
cd /etc
ln -sf /usr/share/zoneinfo/Europe/Zurich localtime

# or temporarly
export TZ=Europe/Zurich

# read /etc/localtime; display daylight saving dates
zdump -v /etc/localtime | grep 2012


routing, routes, route dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# netstat -nr 				Zeigt die routing Einträge an
statische Routen auf RHEL hinzufügen
# route add default gw <defaultGW>
# route add -net 10.0.0.0 netmask 255.0.0.0 gw 10.8.2.65 eth0
# route add -net 10.0.0.0 netmask 255.0.0.0 dev ppp0
# route -n
statische Routen in File sichern
echo '10.0.0.0/8 via 10.8.2.65' >> /etc/sysconfig/network-scripts/route-eth0

Link,link up/down, Netzwerkkabel angeschlossen, Kabel angeschlossen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mii-diag -s <adapterName>		Bsp: # mii-diag -s eth0			approved on RHEL
# ethtool <adapterName>	
	if link is down check /etc/sysconfig/network-scripts for a file called ifcfg-ethX


# ifcfg, network config files, ifcfg-eth, network dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# /etc/sysconfig/network-scripts
DEVICE=eth0
IPADDR=208.164.186.1
NETMASK=255.255.255.0
NETWORK=208.164.186.0
BROADCAST=208.164.186.255
ONBOOT=yes
BOOTPROTO=none or dhcp
USERCTL=no
HWADDR=00:08:98:8d:77:34

# configure VLANs or vlan:
# ifcfg-eth0:
DEVICE=eth0
ONBOOT=yes
HWADDR=00:08:98:8d:77:34

# copy the ifcfg-eth0 and name the file as ifcfg-eth0.<vlanID>):
DEVICE=eth0.<vlanID>
VLAN=yes
IPADDR=208.164.186.1
NETMASK=255.255.255.0
ONBOOT=yes
BOOTPROTO=none or dhcp
USERCTL=no
HWADDR=00:08:98:8d:77:34

# vlan tagged bonded interface:
# vlan tagging can either be done on bond dev or on both slave devs
# /etc/sysconfig/network-scripts/ifcfg-bond1
DEVICE="bond1"
ONBOOT="yes"

# /etc/sysconfig/network-scripts/ifcfg-bond1.11
VLAN="yes"
DEVICE="bond1.11"
ONBOOT="yes"
IPADDR="10.99.0.45"
NETMASK="255.255.255.0"

# /etc/sysconfig/network-scripts/ifcfg-p1p1
DEVICE="p1p1"
HWADDR="90:E2:BA:07:B0:B4"
ONBOOT="no"
MASTER="bond1"
SLAVE="yes"

# /etc/sysconfig/network-scripts/ifcfg-p1p2
DEVICE="p1p2"
#HWADDR="90:E2:BA:07:B0:B5"
ONBOOT="no"
MASTER="bond1"
SLAVE="yes"

# CONFIGURE BONDING
# /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
IPADDR=10.10.128.20
NETMASK=255.255.255.0
NETWORK=10.10.128.0
BROADCAST=10.10.128.255
BOOTPROTO=none
TYPE=Ethernet
ONBOOT=yes

# /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=78:e3:b5:05:72:98
MASTER=bond0
SLAVE=yes
BOOTPROTO=none
TYPE=Ethernet
ONBOOT=no

# /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
HWADDR=78:E3:B5:05:72:9C
MASTER=bond0
SLAVE=yes
BOOTPROTO=none
TYPE=Ethernet
ONBOOT=no

# /etc/modprobe.conf
alias bond0 bonding
options bond0 mode=1 miimon=100

# do not use
	install ipv6 /bin/true
# in modprobe.conf. bonding needs ipv6 module! use instead:
	options ipv6 disable=1

# get/change bonding settings at runtime:
cat /sys/class/net/bond0/bonding/mode
cat /proc/net/bonding/bond1
ifdown bond0
echo active-backup > /sys/class/net/bond0/bonding/mode
ifup bond0

# bonding modes:
active-backup	1	failover mode
balancd-rr		0	round robin load balanced
xor				2	
broadcast		3
ieee 802.3ad	4
tlb				5
alb				6

# CONFIGURE BRIDGE
DEVICE=eth0
ONBOOT=yes
BRIDGE=br0
HWADDR=b8:ac:6f:65:31:e5

DEVICE=br0
TYPE=Bridge
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.10.21.70
NETMASK=255.255.255.0
DELAY=0

brctl show		# display configured bridges

# network devices known by the system:
ll /sys/class/net/

# NetworkManager flapping issue after moving server (change subnet)
# ERROR: Jan 10 10:10:01 myhost NetworkManager[834]: <error> [1515575401.9418] platform-linux: do-add-ip4-route[2: 10.0.xyz.0/24 100]: failure 101 (Network is unreachable)
# SOLUTION:
nmcli connection show ens192
...
ipv4.addresses:                         10.0.32.28/24
ipv4.gateway:                           10.0.32.1
ipv4.routes:                            { ip = 10.0.xyz.0/24, nh = 10.0.yz.252 } # <== wrong gateways

nmcli connection modify ens192 -ipv4.routes '10.0.xyz.0/24 10.0.yz.252'
nmcli connection up ens192


# virtual IP on eth0, virtual nic
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# copy /etc/sysconfig/network-scripts/ifcfg-eth0 to /etc/sysconfig/network-scripts/ifcfg-eth0:0
# edit the new file according yout needs


# ip forward
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 1 > /proc/sys/net/ipv4/ip_forward

# persistenly, set in /etc/sysctl.conf:
net.ipv4.ip_forward = 1


tcp keepalive
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/proc/sys/net/ipv4/tcp_keepalive_*

/etc/sysctl.conf:
net.ipv4.tcp_keepalive_time = 7200
net.ipv4.tcp_keepalive_intvl = 75
net.ipv4.tcp_keepalive_probes = 9


ip command, ip dinge, networking dinge, net dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ ip addr show
# ip addr add 10.12.0.117/21 dev ens192			# add an additional IP to interface en192
# ip link set dev ens192 up				# brings the interface up


hostname change
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/sysconfig/network	change the entry HOSTNAME=
/etc/hosts		change related entry

split full qualified hostname:
$ hostname | awk -F. '{ print $1 }'


iscsi dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
iSCSI (target) filer installation (CentOS 6.1 x86_64)
# yum install scsi-target-utils
# vi /etc/tgt/targets.conf
<target iqn.2011-12.com.trivadis:quorum>
    backing-store /dev/sdb1
</target>
# service tgtd start; chkconfig tgtd on
# service iptables stop; chkconfig iptables off

setup the iSCSI initiator (client)
# yum install iscsi-initiator-utils scsi-target-utils
# iscsiadm -m discovery -t sendtargets -p 192.168.55.78
	the iqn displayed is the name of the iSCSI target (the one that provides the LUNs)
# iscsiadm -m discovery -P1
# iscsiadm -m node -T iqn.2011-12.com.trivadis:quorum -p 192.168.55.78 --login
# iscsiadm -m node -T iqn.2011-12.com.trivadis:quorum -p 192.168.55.78 --login -d 8	debugging mode
# iscsiadm -m node -T iqn.2011-12.com.trivadis:quorum -p 192.168.55.78 --logout
now some targets (like netapp) needs to know the initiator name. display the initiator name:
# cat /etc/iscsi/initiatorname.iscsi
# iscsi-iname
# iscsiadm -m session -P 3
# iscsiadm -m session -P 0	display infos on registered targets (0-3 means less-more infos)
if the target made the correct mapping (lun - initiator) then you should see the disks under "Attached SCSI devices"
# service iscsi status
# chkconfig iscsi on
# iscsiadm -m node -T iqn.2011-12.com.trivadis:quorum -p 192.168.55.78 --op update -n node.startup -v automatic

rescan for changes/new luns
# iscsiadm -m session -R -P1

configuring targets (to create an iSCSI server)
/etc/tgt/targets.conf
<target iqn.2008-09.com.example:server.target1>
    backing-store /srv/images/iscsi-share.img
    direct-store /dev/sdd
</target>
This example defines a single target with two LUNs. LUNs are described with either the backing-store or direct-store directives where backing-store refers to either a file or a block device, and direct-store refers to local SCSI devices. Device parameters, such as serial numbers and vendor names, will be passed through to the new iSCSI LUN.

# service tgtd start
# tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2012-04.trivadis.com:target1 
# tgtadm --lld iscsi --op show --mode target

configuring iscsi for a specific interface
# iscsiadm -m iface -P1			get iscsi interface infos
	add following entry to /var/lib/iscsi/ifaces/<yourInterface>
iface.ipaddress = <IPaddress>
	if there are actvice sessions, logout
# iscsiadm -m node -T <targetName> -p <iSCSIHost> --logout
	start discovery on specific interface:
# iscsiadm -m discoverydb -t st -p <iSCSIHost> -I bnx2i.2c:76:8a:ab:23:65 --discover
	login to the target over specified interface
# iscsiadm -m node -T <targetName> -p <iSCSIHost> -I bnx2i.2c:76:8a:ab:23:65 --login

iscsi commands on RH AS 4:
config file: /etc/iscsi.conf
# iscsi-ls -l		lists iscsi target and LUNs
# iscsi-rescan		scans for new LUNs


# track, trace system calls
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
truss -o <outputFile> <command>
strace -o <outputFile> <command>


# ssh login without password, ssh dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ssh-keygen -t rsa -b 2048				# on host A as user a, do not set a password
ssh b@B mkdir -p .ssh					# do this if directory .ssh in user a's home not already exists
cat ~/.ssh/id_rsa.pub | ssh b@B 'cat >> .ssh/authorized_keys'
ssh-copy-id -i id_rsa b@B

# avoid host key verification prompting at first ssh connect
ssh-keyscan <server1> <server2>  >> .ssh/known_hosts

# generate key unattended (e.g. in a script) for specific user:
su - <user> -c "ssh-keygen -N '' -t rsa -b 2048 -f /home/oracle/.ssh/id_rsa"

# very slow ssh login
# /etc/ssh/sshd_config set 'UseDNS no'
# add IP of the connecting host and of the server to both /etc/hosts
# if still slow, check dns timeout in /etc/resolv.conf (see 'dns dinge')

#display x forward over a jumphost
ssh -tX <user>@<jumphost> ssh -X <user>@<targetHost>
# if netcat (nc) is available on jumphost:
ssh -oProxyCommand="ssh -qax <user>@<jumphost> nc %h %p" -X <user>@<targetHost>

# use ssh as a SOCKS/socks proxy:
ssh -D 1234 user@host.example.com
# And then tell your web browser to use a SOCKS v5 proxy on localhost at port 1234 


# create ssh tunnel
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# auf dem Proxy Host in der /etc/ssh/sshd_config:
	AllowTcpForwarding yes
# vom localhost aus:
ssh -L$LOCALPORT:$REMOTEHOST:$SSHPORT $PROXYHOST
# $PROXYHOST: the machine you've got SSH access to
# $REMOTEHOST: the machine that $PROXYHOST can connect to, but you can't. Use a hostname or IP that $PROXYHOST can use to refer to the machine
# $SSHPORT: the port that sshd is listening for on remotehost; most likely 22
# $LOCALPORT: the local outbound port SSH is opening up on your local machine that forwards to port 22 on $REMOTEHOST
# Leave that connection up to keep the tunnel working. You might want to also add -N to the command so that this connection won't bring up a remote shell and you won't accidentally close it later.

# Once the tunnel is established, do the following:
ssh -p $LOCALPORT localhost

# This attempts an SSH connection to your local machine on the port that's forwarded to the $REMOTEHOST's SSH port.

# Jumphost config
Host *
  ForwardAgent yes
  ForwardX11 yes
  StrictHostKeyChecking no

Host jumphost-xy jumphost-xy.domain.ch
  HostName jumphost-xy.domain.ch
  ForwardAgent yes
  User chrigi

Host *xy*.domain.ch !jumphost*-xy.* *xy*.domain 
  ProxyCommand ssh jumphost-xy -W %h:%p
  User root



# linux browser, curl dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
curl -C - -O https://blabla.com/path/to/arch.tgz	# -C -: nimmt bei Abbruch offset auf und faehrt fort, -O erstellt lokales File
curl -H "Host: test.local" localhost			# testing a virtualhost running on localhost


# RemoteDesktop, RDP remote Desktop Session auf Windows
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rdesktop -k <tastaturlayout> <servername>:<port>
rdesktop -k de-ch server:3389				# Bsp mit Standartport RDP Windows
rdesktop -u <user> -d <domain> -p <password> -g 75% -k de-ch dcttc01.ttc.trivadis.com


# set/change kernel parameters
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# in File: /etc/sysctl.conf
man proc		# get infos on a specific kernel parameter
sysctl -a		# displays active kernelparameters
sysctl -p 		# activates the values set in /etc/sysctl.conf

# Oracle specific parameters (11g)
# kernel.shmmax
# 	physical RAM / 2 in bytes
# kernel.shmall
# 	max shared memory segments system wide in pages
# 	get system pagesize: 
	# getconf page_size
# 	e.g.: 60GB to define as shmall: 60*1024*1024*1024 / <page_size>
# kernel.sem = 250 32000 100 128
# 	semaphores: semmsl, semmns, semopm, semmni


# root password, password expire, password dinge, /etc/shadow
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# basic useradd command
useradd -r -u 200 -m -c "nexus role account" -d ${SONATYPE_WORK} -s /bin/false nexus
# password things
chage -M -1 root	# (RHEL) Das Passwort für root laeuft nie ab
chage -E -1 root	# (RHEL) Der Account von root laeuft nie ab
# useradd with password crypt
useradd -d / -g users -p $(perl -e'print crypt("password", "aa")') -M -N username


# read codes, output redirection
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo $?			# error code
echo $!			# process id
1>filename		# Redirect stdout to file "filename."
1>>filename		# Redirect and append stdout to file "filename."
2>filename		# Redirect stderr to file "filename."
2>>filename		# Redirect and append stderr to file "filename."
&>filename		# Redirect both stdout and stderr to file "filename."
2>&1			# Redirect stderr to stdout


# parted, partitioning dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
parted -s /dev/sdd print
parted -s /dev/sdd mkpart primary 1MB 1000MB		# creates a first partition 1GB
parted -s /dev/sdd mkpart primary 1000MB 100%		# creates a second partition with the rest

# using parted interactively
parted
	(parted) print all
	(parted) select /dev/sdb
	(parted) mktable gpt						# for GPT partitioning
	(parted) mktable msdos						# for MBR partitioning
	(parted) mkpart primary ext4 1MB 400GB		# create prim partition from 1MB to 400GB
	(parted) mkpart primary linux-swap 400GB 402GB
	(parted) set 1 boot on						# make partition 1 bootable
	(parted) rm 2								# remove partition 2
partprobe /dev/sdb								# propagate changes to the kernel

# inform kernel about partition changes
partx -a /dev/sdX					# telling the kernel about presence and numbering of on-disk partition
kpartx /dev/sdX						# create dev maps from partition table


# lvm standard procedure, lvm dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# new lvm commands:
pvs						# display pv status
vgs						# display vg status
lvs						# display lv status
lvs -a -o +devices		# display lv status and apropriate devices

fdisk /dev/cciss/c0d1		# <- legacy command, use parted if you really need partition. otherwise use:
							# do not create physical partitions in combination with LVM. It is not possible to resize physical LVM partition!
pvcreate /dev/cciss/c0d1
vgcreate oravg /dev/cciss/c0d1p1
vgdisplay -v oravg									# displays details about oravg
lvcreate -L 700G -n u01lv oravg /dev/cciss/c0d1p1	# or
lvcreate -l 100%FREE -n u02lv oravg					# takes 100% of the free space of oravg for lv u02lv
mkfs.ext3 -L <labelname> /dev/oravg/u01lv
mount LABEL=<labelname> /u01

# lvm, lv logical volume extend, vergroessern, resize
# Attention: backup your data before you start
# If a physical partition is used, gparted or parted are not able to resize the LVM physical volume. You have to create an additional partition.
fdisk /dev/sdd -> create new additional partition
partprobe -s /dev/sdd
vgextend u03vg /dev/sdd2
lvextend -r /dev/u03vg/u03lv /dev/sdd2				# extends u03lv with the whole space on /dev/sdd2
resize2fs /dev/u03vg/u03lv
xfs_growfs /dev/mapper/u03vg-u03lv					# extends a XFS FileSystem

# resize LVM LUN
pvresize <physicalVolume>
lvresize <logicalVolume>

lvextend /dev/<volumegroup>/<logicalvolume> -L1000m			# achtung: das volume wird so 1000mb gross und nicht um 1000mb vergroessert
umount /var								# u.u. geht das nur im single user mode, bei / nur mit livesystem
e2fsck -f /dev/<volumegroup>/<logicalvolume>
resize2fs /dev/<volumegroup>/<logicalvolume> 1000m			in case of any errors use -f option
fsadm resize /dev/<volumegroup>/<logicalvolume> 20G -v		use for ext4 filesystems
mount -a

# lvm, lv logical volume shrinken, shrinking, reduce, verkleinern
# Bevor man anfaengt Backup sicherstellen!
# ACHTUNG umount des entsprechenden Volumes ist notwendig
umount /u01
e2fsck -f /dev/<volumegroup>/<logicalvolume>
resize2fs /dev/<volumegroup>/<logicalvolume> [size]			without [size] given filesystem equals partition/ volume size
lvreduce -L1000M /dev/<volumegroup>/<logicalvolume>
mount -a

# lvm excludes, lvm filter
# with an attached SAN it can be useful to exclude luns from lvm scans. Adjust the /etc/lvm/lvm.conf with a filter like:
filter = [ "a|^/dev/sda$|", "a|^/dev/sda[0-9]$|", "r/.*/" ]			# this filter excludes all devices except /dev/sda and its partitions
filter = [ "a/cciss.*/", "a/emcpower.*/" "a/sd[e|f|g|h|i].*/" "r/sd.*/" ] 	# this filter excludes all sd devices except sde-i
# IMPORTANT: test your filter with # vgscan -vvvv before booting! (there should be no 'skipping' on root device)

# replace a physical volume (tested on vg with mounted lv!)
vgextend redo1vg /dev/sde			# redo1vg: volumegroup  /dev/sde: new physical volume 
vgdisplay -v redo1vg 
pvmove -v /dev/emcpowerb1 /dev/sde		# move from old volume (emcpowerb1) to new volume
vgreduce redo1vg /dev/emcpowerb1

# move a LV from (fromVG) to another VG (toVG) (only offline! not possible for root VG volumes)
lvchange -a n fromVG/lv_u00					# deactivates lv_u00 (do this for all LVs in fromVG)
vgsplit -n fromVG/lv_u00 fromVG toVG		# moves lv_u00 with all its PVs to toVG
lvchange -a y toVG/lv_u00					# activates lv_u00 (now you are able to mount u00 again)
pvmove /dev/fromVGvolume /dev/toVGvolume	# see that toVGvolume has enough space
vgreduce toVG /dev/fromVGvolume				# removes fromVGvolume from toVG

# create online Backup of LV (clone):
vgextend appvg /dev/cciss/c0d0p9							# add additional PV to VG
lvconvert -m1 appvg/lv_usr									# create a mirror with specific LV
lvconvert --splitmirrors 1 --name lv_usr_bkp appvg/lv_usr	# split the mirror into two LVs, new LV called lv_usr_bkp
lvchange -a n appvg/lv_usr_bkp								# set new LV to inactive (optional)
vgsplit appvg appvg_bkp /dev/cciss/c0d0p9					# create new VG with cloned LV (optional)

# lvm snapshots:
lvcreate --size 1G --snapshot --name vm01-disk-snap /dev/vg0/vm01-disk	# creates a snapshot from LV vm01-disk
lvconvert --merge /dev/vg0/vm01-disk-snap								# restores snapshot (LV vm01-disk must be unmounted!)

# rename a VG
vgrename <oldVGname> <newVGname>
# if root VG name changed, adjust the following files:
	/boot/grub/menu.lst
	/etc/fstab
	/etc/blkid/blkid.tab

# moving a VG to another server:
# vgexport and vgimport is not necessary to move disk drives from one server to another. It is an administrative policy tool to prevent access to volumes in the time it takes to move them.
unmount /appdata
# Marking the volume group inactive removes it from the kernel and prevents any further activity on it.
vgchange -an appvg
vgexport appvg
vgs -v			# Look at the third attribute, should be an x, then its successfully exported
# Now, When the machine is next shut down, the disk can be unplugged and then connected to it's new machine
pvscan
# If you are importing on an LVM 2 system, run:
vgimport appvg
# You must activate the volume group before you can access it.
vgchange -ay appvg
mkdir -p /appdata
mount /dev/appvg/appdata /appdata
# The file system is now available for use. 

# lvm, Can't open /dev/sdz exclusively.  Mounted filesystem?
# check for other partitions pointing on the same device
cat /proc/partitions
# example:
# [root@ols-rac2 ~]# cat /proc/partitions
# 65   144  188743680 sdz
# 253    29  188743680 dm-29
# if the #blocks is the same, then its the same device
# find out the dm name of the device dm-29
# [root@ols-rac2 ~]# ll /dev/mpath/ | grep dm-29
# lrwxrwxrwx 1 root root 8 Oct 17 14:00 3600a0b8000266ab6000013ad4e9b9cbe -> ../dm-29
# [root@ols-rac2 ~]# dmsetup status | grep cbe
# 3600a0b8000266ab6000013ad4e9b9cbe: 0 377487360 multipath 2 0 0 0 1 1 A 0 1 0 65:144 A 0 
# [root@ols-rac2 ~]# dmsetup ls | grep cbe
# 3600a0b8000266ab6000013ad4e9b9cbe	(253, 29)
# [root@ols-rac2 ~]# dmsetup remove 3600a0b8000266ab6000013ad4e9b9cbe
# try again to create physical volume


i/o block size, direct i/o, block alignment
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LVM by default detects block alignment. Therefore do not use fdisk, create PVs directly on the volume.
/etc/lvm/lvm.conf:
    md_chunk_alignment = 1
    data_alignment_detection = 1
    data_alignment = 0
    data_alignment_offset_detection = 1

sysfs parameter:
/sys/block/<disk>/alignment_offset
/sys/block/<disk>/<partition>/alignment_offset
/sys/block/<disk>/queue/physical_block_size		sector size on LUN
/sys/block/<disk>/queue/logical_block_size
/sys/block/<disk>/queue/minimum_io_size
/sys/block/<disk>/queue/optimal_io_size
/sys/block/<disk>/queue/rotational			0=SSD; 1=Harddisk; SSD always use 4K blocks; needs kernel 2.6.32 or higher


filesystem dinge, fs dinge, ext dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# tune2fs -l /dev/<device>	use with ext2/3
# tune4fs -l /dev/<device>	use with ext4

Task									ext4		XFS
Creating a file system					mkfs.ext4	mkfs.xfs
Resizing a file system					resize2fs	xfs_growfs 
Repairing a file system					e2fsck		xfs_repair
Changing the label on a file system		e2label		xfs_admin -L
Reporting on disk space and file usage	quota		quota
Debugging a file system					debugfs		xfs_db
Saving critical fs metadata to a file	e2image		xfs_metadump


change disklabel 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# e2label /dev/sdx1 <labelname>


# batterie, battery status pruefen, power, strom
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
acpi [-t Temperatur] [-V verbose]


# awk dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cat lala.txt | awk '{print $1}'					# prints the first column
cat lala.txt | awk 'BEGIN { FS = ":" } ; { print $1 }'		# separats by :
awk -F: '{ print $2 }'						# separates by : and uses the second field
hostname | awk -F. '{ print $1 }'				# prints the hostname out of a full qualified hostname
awk 'NR==3' <file>						# prints line number 3 (starts line counting by 1)
awk 'NR==3 {print $2}' <file>					# prints the 2. column of the 3.line
cat lala.txt | awk '$3 ~ /.*<pattern>.*/ {print $1" "$5}'	# greps for <pattern> in the 3.column and prints the 1. and the 5. column
awk '{printf "%s+",$0} END {print ""}'				# replaces linebreaks with +



# Kommandozeile, commandline
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Zum Anfang der Zeile springen:	Ctrl+A
Zum Ende der Zeile springen:	Ctrl+E


# screen dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
screen				# startet einen neuen screen
screen -ls			# zeigt alle gestarteten screens
screen -R			# attaches a already running screen (which is not yet attached)
screen -x <PID>		# attaches to an already attached screen session with pid <PID>
screen -L 			# turns on screen logging to file screenlog.xy
Ctrl+a c			# create new screen
Ctrl+a n			# next screen
Ctrl+a p			# previous screen
Ctrl+a <0-9>		# wechselt zu screen 0-9
Ctrl+a Ctrl+a		# wechselt zum vorherigen screen
Ctrl+a Alt+ü		# (on MacBook) this will switch to copy-mode, now you can scroll back and forth with the arrow keys
Ctrl+a [			# this will switch to copy-mode, now you can scroll back and forth with the arrow keys
Ctrl+a S			# splits the screen horizontally
Ctrl+a | or V		# splits the screen vertically
Ctrl+a X			# close the current region
Ctr-+a D			# detach the screen


tty, serielle Verbindung, serial connection
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# dmesg | grep -i usb
# agetty -L /dev/ttyUSB3 <baudrate> vt100	(not verified, maybe: # agetty -L ttyUSB3 <baudrate> vt100
<baudrate>: # 4800 bps, 9600 bps, 19200 bps, 38400 bps (Linux-Terminal Standard), 57600 bps, 115200 bps (max)


which process is using which file, fuser, lsof
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# fuser -c /tmp
# ps -o pid,args -p "$(fuser -c / 2>/dev/null)"		gets all open files
# lsof


# yum, yum dinge, package manager
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
yum list									# shows all installed packages
yum repolist [all|enabled|disabled]			# shows repos
yum-config-manager --enable <repo>			# needs yum-utils
yum provides \*bin/htpasswd					# searches for packages containing bin/htpasswd
yum search --showduplicates <string>		# shows all available packages not only the latest
yum check-update							# checks repository server for new updates
yum update [--exclude=<packagename>]		# updates all packages with newer version available
repoquery --list <packagename>				# list files in package, needs yum-utils installed
# to update from the Redhat network: rename the installserver .repo file to .repo.tmp
# the server should use the rhel-debuginfo.repo file

# setting up a yum respository
yum install httpd	(you can also use ftp instead)
rsync -av <user>@<installserver>:/path/to/repository /var/www/html
yum install createrepo
createrepo -g [--database] [-v] /var/www/html
# open port 80 on firewall if one is running!

# setting up a local yum repo
cp -rp /path/to/iso /local/repo
cd /local/repo
createrepo .
# create /etc/yum.repos.d/local.repo:
[local_repo]				do not use spaces in here!
baseurl=file:///local/repo
enabled=1

# create a mirror repo
yum install yum-utils
cat /etc/yum.repos.d/fedora-mirror.repo
[f16-x86_64-release]
name=Fedora $releasever - $basearch - Release
failovermethod=priority
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-16&arch=x86_64
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$basearch

reposync -r f16-x86-64-release -p /srv/www/html/repos/
createrepo /srv/www/html/repos/f16-x86_64-release/
# removing old packages:
repomanage --old . | xargs rm -rf


# error: error performing checksum
# recreate your repo with the following command:
createrepo -v -s sha1 /path/to/your/repo

# error: no groupdata available for configured repositories
createrepo -g comps-xyz.xml /path/to/your/repo
# comps-xyz.xml is located in .iso repodata dir

# error: rpmdb: Lock table is out of available locker entries
mkdir /tmp/rpm
mv /var/lib/rpm/__db.00* /tmp/rpm


Email, Thunderbird with Exchange
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In Thunderbird das Kalender-Addon Lightning installieren
(ubuntu: apt-get install xul-ext-lightning; sonst tools->add-ons-> Get 
Add-ons, Suche nach lightning)

Danach das Add-on "Provider for Microsoft Exchange" installieren

Nach Restart konfigurieren:
Links im Bereich der Kalenderliste rechte Maustaste -> New Calendar -> 
On the Network
(*) Microsoft Exchange
Location: https://<xyz>@intranet.trivadis.com/EWS/Exchange.asmx
(<xyz>: Dein 3stelliges Kurzzeichen)


# memory, mem, swap dinge, mem dinge, memory dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cat /proc/swaps		# displays swap devices
cat /proc/meminfo
vmstat -S m 1		# shows memory/swap every second in MB
free -m				# shows memory/swap in MB
pmap <pid>			# mem infos to process <pid>
top					# press O for sort selection

# in the "free" output the free amount is not the memory that is available if needed.
# To get the available amount of mem read the buffer (memory used for disk caching operations) line
#              total       used       free     shared    buffers     cached
# Mem:           238        168         70          0          4         68
# -/+ buffers/cache:         94        143
# the 143 in this example is the mem available

# ps_mem.py		script to display total memory consumption per application (see ressource dir)
# output:
# ....
#  1.0GB  +  723.2MB = 1.7GB       oracle (117)
# ------------------------------
# Private + Shared   = RAM used    if "RAM used" reaches Memory Max Target, a possible need for more memory exists!
#   PGA   +  SGA

# resize swap logical volume:
swapoff -v /dev/vg_root/lv_swap
mkswap /dev/vg_root/lv_swap
swapon -v /dev/vg_root/lv_swap

# check the result
swapon -s
cat /proc/swaps


# ps, processes, prozesse, ps dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ps auxw | sort -nk4			# sorts the processes to the 4th colummn
ps auxw | sort -rnk4		# sorts the processes to the 4th colummn in reverse order


# performance
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Disk I/O:
iostat -p sdb 3
iostat -dx <interval> <repetition>
iostat -dx 5 10 | awk '{now=strftime("%Y-%m-%d %T "); print now $0}'		# prints iostat with timestamp


# health check, HEALTH CHECK, analyse, analysis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
history; last ; uptime ; last reboot;
aureport							# report of auditd
aureport -l							# report of logins
ausearch -ts mm/dd/yyyy				# search utility for auditd
aulastlog							# last logged in
uname -a;id;uptime;date;free -mtol;who;cat /proc/cpuinfo;echo $PATH;df -m; sysctl vm;
ip addr show ; ip route show ; ip neigh show; ip rule list; head /etc/resolv.conf
ps -eo pid,ppid,rss,vsize,pcpu,pmem,cmd -ww --sort=pid
df -i; cat /proc/mdstats;
for i in *; do echo -n "$i: "; find $i -type f | wc -l; done						# --  (count files under directories)
find . -type f -size +30000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'		# --  (check for files more then 30000kb)
zcat messages-* | grep -i warning | less
zcat messages-* | grep -i fatal | less
dmesg | less
sysctl -a


redhat network registration, rhn, rhel dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# rhn_register	graphical tool
# rhnreg_ks --username=<RHNuser> --password=<RHNpw> --proxy=https://<proxy>:<port> --proxyUser=<proxyUser> --proxyPassword=<proxyPassword>

for oracle linux:
	# up2date --register

register a system in RHN
	# subscription-manager register --username=<rhnuser>
	# subscription-manager list --available --all				# see your subscription
	# subscription-manager attach --pool=<pool_id>				# attach to a pool
	
attach additional repositories
	# subscription-manager repos --enable=rhel-7-server-extras-rpms


cobbler dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import new distro:
	cobbler import --name=centos7min --arch=x86_64 --path=/mnt
	cobbler sync
	cobbler validateks			kickstarts validieren

start install server (cobbi, local VM):
	installsrv status
	installsrv start
	cobbler sync

cobbler management:
	cobbler distro list
	cobbler distro report --name <distro>
	cobbler profile list
	cobbler system list


############################################################################
#
# SUSE, SuSE, suse, SuSe
#
############################################################################

@SUSE: zypper dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zypper se 				list all packages (se=search)
# zypper se -i <searchString>		search for installed packages
# zypper info <package>			get infos for <package>
# zypper info -t patch <package>	get infos for patch <package>
# zypper wp <package>			get dependencies for <package>

# zypper patches			listing patches
# zypper patch				applying patches
# zypper lu				list updates
# zypper up				update
# zypper dup				distribution upgrade

# zypper lr				list repositories
# zypper mr --enable <repoAlias>	enables a repo
# zypper mr --disable <repoAlias>	disables a repo


@SUSE: remote x win connections, xwin, x windows, x server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Folgende Schritte um erfolgreich eine Xsession auf ein SLES aufzumachen
make sure xauth packacke is installad on remote host. Connect to remote host with
# ssh -X user@hostname
do not set DISPLAY variable, it's already correctly set. Do either switch user otherwise you will lose the correct DISPLAY setting.

IMPORTANT: check /etc/ssh/sshd_config for the following settings enabled:
		X11Forwarding yes
	for console access use: ssh -XC username@host
	in putty enable X11 Forwarding under: Connection - SSH - X11
	ATTENTION: you have to log in with user oracle. If you su to another user you'll lose the authentication cookie. On Linux try:
		$ echo $DISPLAY			only necessary on Solaris
		$ xauth list			copy the output line to clipboard, if there are more try the one with :10
			on solaris xauth is in /usr/openwin/bin/
		$ su - <desiredUser>
		$ xauth add <pasteCopiedLine>
		$ export DISPLAY=<outputOfDISPLAYfromOtherUser>

@SUSE: network configs, scripts, hostname
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
configs in: /etc/sysconfig/network
hostname in: /etc/HOSTNAME
# ifup <interface>
# ifdown <interface>
# ifstatus <interface>

############################################################################
#
# DEBIAN, UBUNTU, debian
#
############################################################################

@DEBIAN: encfs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# encfs ~/.foobar ~/foobar 	mount encrypted filesystem
# fusermount -u ~/foobar 	umount encrypted filesystem

@DEBIAN: sudo authentication with ssh keys
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
http://drhevans.com/blog/posts/195-using-ssh-agent-for-sudo-authentication
$ wget "http://downloads.sourceforge.net/project/pamsshagentauth/pam_ssh_agent_auth/v0.9.3/pam_ssh_agent_auth-0.9.3.tar.bz2"
$ tar -xjvf pam_ssh_agent_auth-0.9.3.tar.bz2
$ cd pam_ssh_agent_auth-0.9.3
$ sudo apt-get install libssl-dev libpam0g-dev
$ ./configure --libexecdir=/lib/security --with-mantype=man
$ make
$ sudo make install
At this point, it would be wise to open another terminal and sudo su - to root.
$ sudo vi /etc/sudoers		add the following line:
Defaults env_keep += SSH_AUTH_SOCK
$ sudo vi /etc/pam.d/sudo	add the 'auth [success=.....' above the line '@include common-auth'
auth [success=3 default=ignore] pam_ssh_agent_auth.so file=~/.ssh/authorized_keys
@include common-auth
...
success=3 means that in case of successful authentication by ssh keys it will skip the next 3 lines
so, see that the line 'session required pam_permit.so' comes after 3 lines from 'auth ...' 
For debugging you can also add debug to the end of the auth line in /etc/pam.d/sudo and get more detailed information logged to /var/log/auth.log.

@DEBIAN: packet, packetmanager, install software, dpkg, apt dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
from 12.x
# apt <list|search|show|etc>
# apt --installed list				list installed packages

# dpkg -l					list installed packages
# dpkg-query -p <packetname>			displays details about installed package <packetname>
# dpkg -L <packetname>				anzeigen wo das Paket installiert ist
# dpkg -i <debPackage>				install .deb package
# apt-cache search <packetname>			nach Packet suchen
# apt-get remove <package> <package>		uninstall/ remove Package
convert rpm to dep
# alien <rpmPacket> 

# aptitude update				updates the system
# aptitude dist-upgrade				upgrades to latest release


@DEBIAN: installed hardware infos
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Including device - driver mapping
# lspci -nnk

@DEBIAN: ein Modul vom laden in den Kernel auschliessen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
im dir: /etc/modprobe.d ein File mit der .conf Erweiterung anlegen, mit folgendem Inhalt:
	blacklist <modulname>
	options <modulname> modeset=0


@DEBIAN: chroot Umgebung auf Ubuntu
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
setzt eine Ubuntu hardy (8.04) Installation in einer chroot Umgebung auf
out-user$ sudo apt-get install schroot debootstrap
out-user$ sudo mkdir /var/chroot 
out-user$ sudo editor /etc/schroot/schroot.conf

	# Contents of file /etc/schroot/schroot.conf
	[hardy]
	description=Ubuntu hardy
	location=/var/chroot/hardy
	priority=3
	users=f2821796
	groups=users
	root-groups=root

out-user$ sudo debootstrap --arch i386 hardy /var/chroot/hardy http://archive.ubuntu.com/ubuntu/
out-user$ sudo cp /etc/resolv.conf /var/chroot/hardy/etc/resolv.conf
out-user$ sudo cp /etc/apt/sources.list /var/chroot/hardy/etc/apt/
out-user$ sudo chroot /var/chroot/hardy

Warnungen bei addgroup:
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:

# export LANGUAGE=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# locale-gen en_US.UTF-8
# dpkg-reconfigure locales

@DEBIAN: install Qualcomm UMTS device on Ubuntu 11.04 on Lenovo ThinkPad W510
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. get the drivers from Lenovo factory installation of Windows:
C:/Program Files (x86)/QUALCOMM/Images/Lenovo
copy the two files of UMTS/ dir and the one from dir 6/ to
/lib/firmware/gobi	(create dir if not exists)
2. get gobi_loader from: http://www.codon.org.uk/~mjg59/gobi_loader/
3. unpack gobi_loader and run as root make and make install
4. check if /etc/udev/rules.d/ contains a gobi rule (named something like 60-gobi.rules)
if not, copy the one from the gobi_loader tarball to /etc/udev/rules.d/
5. reload qcserial module as root (modprobe -r qcserial and modprobe qcserial) or just reboot
6. Network-Manager should now be able to start a UMTS connection


@DEBIAN: VNC, vnc client
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
is called: vinagre


@DEBIAN: network
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/network/interfaces:
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
address 192.168.55.80
netmask 255.255.255.0
gateway 192.168.X.X
network 192.168.55.0
broadcast 192.168.55.255

/etc/init.d/networking restart

# dns setup
/etc/reslovconf/resolv.conf.d/base
nameserver x.y.z.x
nameserver x.y.z.y

resolvconf -u

# default gateway manual add
sudo route add default gw 192.168.1.254 eth0



############################################################################
#
# FREEBSD
#
############################################################################

#@FREEBSD: user dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pw user mod root -s `which bash`		# sets the shell to bash for user root


#@FREEBSD: system config
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# in /etc/rc.conf:
keymap="swissgerman.iso.acc"		# keyboard layout
hostname="<hostname>"


#@FREEBSD: system info
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dmesg | grep memory						# memory infos
sysctl -a | grep mem					# memory infos
swapinfo								# swap info
sysctl -n kern.ostype kern.osrelease 	# OS release info
pciconf -lv								# pendant to lspci


#@FREEBSD: Netzwerk, network config, Konfiguration
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#	/etc/rc.conf
# Syntax im /etc/rc.conf
	ifconfig_<interfaceName>="inet 192.168.1.3 netmask 255.255.255.0"
	oder: ifconfig_<interfaceName>="inet 192.168.1.3/26"
	defaultrouter="10.20.30.1"
# for DHCP:
	ifconfig_<interfaceName>="DHCP"
	# service dhclient start <interfaceName>
# spezielle Routen
	static_routes="irgendwas"
	route_irgendwas="-net <zielnetz> <routerFuerMichSichtbar>"	Bsp: route_irgendwas="-net 172.29.1.0/25 172.29.1.190"
# Interfaces neu starten
/etc/rc.d/netif restart
/etc/rc.d/routing restart


#@FREEBSD: Offene Ports abfragen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
netstat -nat			# bei 'Local Address' ist die letzte zahl hinter der IP die Portnummer
sockstat -4 -l	-4 		# fuer ipv4; -6 fuer ipv6; -l listening sockets; -c connected sockets


# @FREEBSD: Infos zu installierten PCI Adaptern
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pciconf -l


#@FREEBSD: messages, log file, existiert nicht
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
newsyslog -C


#@FREEBSD: pure-ftpd, FTP einrichten
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Installation: /usr/ports/ftp/pure-ftpd/
#Der installiert unter /usr/local/etc (config, rc-script), /usr/local/sbin (binaries)
#ich habe das config ins /etc kopiert und das rc ins /etc/rc.d
#dann die config-Zeile im rc-script angepasst:
	pureftpd_config=${pureftpd_config:-"/etc/pure-ftpd.conf"}
#im /etc/rc.conf folgende Linie einfügen
	pureftpd_enable="YES"
#um als Anonymous einloggen zu können ist ein ftp User auf dem System erforderlich
adduser ftp
#Welcome Banner in: /home/ftp/.banner


#@FREEBSD: NFS einrichten
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#folgende Zeilen ins /etc/rc.conf
	rpcbind_enable="YES"
	nfs_server_enable="YES"
	mountd_flags="-r"
#Falls der Client ebenfalls ein FreeBSD ist: folgende Zeile in sein /etc/rc.conf
	nfs_client_enable="YES"
#Folgenden Eintrag ins /etc/exports:
	/tmp/nfs-test   -alldirs        172.29.149.27
#NFS ohne Reboot starten:
rpcbind
nfsd -u -t -n 4
mountd -r
# Auf dem Client System (RHEL)
mount -t nfs 172.29.149.28:/tmp/nfs-test /tmp/nfs-test
#Error: mount.nfs: rpc.statd is not running but is required for remote locking.
#This is a TCPwrapper issue, add following line to /etc/hosts.allow:
rpcbind: localhost

#@FREEBSD: ports collection, install software, packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#getting started:
csup -L 2 -h cvsup.FreeBSD.org /usr/share/examples/cvsup/ports-supfile	# make sure /usr/ports is empty
find /usr/ports -name pkg-plist | xargs grep -l <searchFile>			# search throu the ports collection and finds all <searchFile>
whereis <packageName>
# to install a port
cd /usr/ports/your/port
make install clean

pkg_version -v										# lists installed ports
pkg_info [-v] <packageName>							# details about <packageName>
pkg_delete <packageName>							# delete a port

# if installation of a port fails check if enough memory is available.

#Error: => Couldn't fetch it - please try to retrieve this
#Resolution: you may have to add another mirror to the ports collection retrieve list.
#add the following to /etc/make.conf (create it if it does not exist)
#MASTER_SITE_BACKUP?=   \
#http://ftp.ch.freebsd.org/pub/FreeBSD/ports/distfiles/${DIST_SUBDIR}/
#MASTER_SITE_OVERRIDE?=  ${MASTER_SITE_BACKUP}
#ftp://ftp.halifax.rwth-aachen.de/freebsd/ports/distfiles/${DIST_SUBDIR}/


#@FREEBSD: disks
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# list available disks:
egrep 'ad[0-9]|cd[0-9]' /var/run/dmesg.boot
gpart create -s gpt da0							# creates a GPT partition on disk /dev/da0
gpart list da0									# display info about da0
gpart show da0									# lists configured partitions on da0
gpart add -s 128 -t freebsd-boot da0			# creates a 64k boot partition on da0
gpart add -t freebsd-zfs -l <label> da0			# creates zfs root partition on da0
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da0	# writes bootcode to da0




############################################################################
#
# SOLARIS
#
############################################################################


@SOLARIS: checksum
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# cksum <file>
# digest -v -a md5 <file>


@SOLARIS: alom
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sc> showplatform		show HW info, list serial number, list domains
sc> showenvironment		health status information
sc> showfaults [-v]
sc> showfru [-g 20]		list a bunch of info on HW [-g 20 stops output after 20 lines]

sc> powercycle			executes a poweroff and poweron
sc> poweroff
sc> poweron

sc> console [-f]		connects to server prompt, exit with #.
sc> logout				exits the alom

sc> resetsc				resets the SC


@SOLARIS: Management console, console output in ascii terminal
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
X must be available
# smc &
# xterm -C &	or
# dtterm -C &

@SOLARIS: user management
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/user_attr			add role based privileges in this file
/etc/default/passwd		set password aging policies
# passwd -x -1 <user>	reset password aging for <user>


@SOLARIS: Prompt anpassen:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/profile
PS1="[\u@\h \w] \$ "

@SOLARIS: Alias erstellen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/profile	(systemwide)
alias ll="ls -al"

@SOLARIS: Patches, Patch anzeigen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# showrev -p
# patchadd -p			list installed patches
# patchadd <patchId>		installs a patch
	>log infos: /var/sadm/patch/<patchId>/log
	/var/sadm/patch/<patchId>	saves copies of files replaced by patch <patchId>
	NOTE: to patch global and local zones, local zones needs to be in 'installed' state (halted) at least
# patchrm <patchId>		removes a patch
# smpatch			automated patch checker


@SOLARIS: top, Prozesse anzeigen, Auslastung, Performance
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# prstat
# prstat -a		lists a summary of consumed ressources for all users
# prstat -s cpu -n 30	top 30 cpu processes
# prstat -s size -n 30	top 30 memory processes


@SOLARIS: package manager, install software, remove package
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/var/sadm/install/contents	contains installed package list
# pkginfo -i			lists all installed packages
# pkgadd -d <packageName>	installs a package
# pkgrm <packageName>		removes installed package
# pkgchk <packageName>		checks a package for accurancy and integrity
# pkgchk -d <packageName> -l 	lists package content

Solaris 11 IPS (ips):
# pkg publisher					lists configured repos
# pkg set-publisher ...				add or modify a repo
# pkg unset-publisher <pubName>			remove a repo
# pkgrepo list -p cacao -s file:///var/opt/sun/xvm/images/IPS/ac-archive.p5p/	lists content of publisher "cacao" in repo location "file:///..."
# pkg list					lists all installed packages
# pkg info <frmi>				details about package <frmi>
	Branch: 0.175.a.b.0.2.537		a=OS Update; b=SRU (support repository update)
# pkg search <searchString>			search the IPS repo for <searchString>
# pkg uninstall driver/network/wlan/*		removes all wlan drivers (groupremove)



@SOLARIS: services, service management facility (smf)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
servicenames are in URI style (called FRMI Fault Managed Resource Identifier). example:
svc://localhost/system/system-log:default		(full qualified so to say :)
svc:/system/system-log:default				(abbreviation)
system/system-log:default				(abbreviation)

# svcs                          all services which are enabled
                -a              display all services
		-xv		display failed services
                -l <FRMI>       long listing, very helpful details if service is not running
                -d <FRMI>       which am i dependent from
                -D <FRMI>       which are dependent of me
                -p <FRMI>       lists processes associated with FRMI; -p '*' lists all FRMIs and its processes
                status: online [*]=in transit, means stop scripts are executed for this service
                status: legacy_run means that smf startd has just executed a initscript start command, but knows nothing about status
# svcadm
                enable <FRMI>   enables FRMI permanently (-t temporarly)
                disable <FRMI>  diables FRMI permanently (-t temporarly)
                restart <FRMI>
                mark            marks FRMI as maintenance i.e.
                clear           removes the maintenance mode and starts the service
# svccfg                        work with the SMF repository DB
                import </path/to/manifest.xml>
		export <FRMI>				prints the whole config of <FRMI> to standard out
                delete <FRMI>
                validate </path/to/manifest.xml>       check for xml compliance, may better use
# svccfg -s <FRMI> listprop				lists all properties of FRMI

# svcprop
                -p start/exec <FRMI>    displays the start method of FRMI

logfile location: /var/svc/log

milestones instead of runlevels
# svcadm milestone -d milestone/single-user:default		the -d parameter sets the default milestone (or runlevel), without -d system will immediately go to the specified milestone
valid major milestones:
milestone/none:default				no services will be started
milestone/all:default				all enabled services will be started
milestone/single-user:default
milestone/multi-user:default
milestone/multi-user-server:default
# boot -m milestone/single-user:default		boots the server into single user

add a service to smf
1. goto /var/svc/manifest and find a similar service
2. copy the similarService.xml to your.xml and edit it according your needs
3. if you also choosed exec path as /lib/svc/method go there
4. copy the similarService script to your script and edit it according your needs
5. validate your xml
	# xmllint --valid /var/svc/manifest/network/ServiceName/myservice.xml	not sure if this is necessary
	# svccfg validate /var/svc/manifest/network/ServiceName/myservice.xml
	# svccfg import /var/svc/manifest/network/ServiceName/myservice.xml
xml/script generator: http://sgpit.com/smf/
xml/script oracle example: /dinge/wissen/solaris/oracleStartStop


@SOLARIS: devices, system infos, lspci, bit, 32, 64
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
install new hardware:
# devfsadm              reconfigure /dev namespace -> hopfully a native driver fits... if not
# devfsadm -C		clears unneeded device files
# prtdiag		hardware infos
# prtpicl -v		very detailed hardware infos, use -c to specify hardware class
# prtconf -v    	gives information about installed hardware  - try to find the new one
find a driver for the hardware and install it
# /usr/sbin/update_drv -a -i '"<pciNumber>"' <driverName>               tell Solaris to use another driver
Example: # /usr/sbin/update_drv -a -i '"pci1186,4b01"' skge

show system infos:
# isainfo -kv    	shows if Solaris is running on 32 or 64 bits (if you see both 32 and 64 its a 64 installation)

cdrom, removable harddisk, usb sticks:
# volcheck
# svcadm restart volfs
cd, dvd mounted on: 	/cdrom/<volname> or /cdrom/cdrom0
usb disk, stick:	/rmdisk

commonly used device drivers:
Device Driver 	Description
fas 			Fast/wide SCSI controller
hme 			Fast (10/100 Mb/sec) Ethernet
isp 			Differential SCSI controllers and the SunSwift card
glm 			UltraSCSI controllers
scsi 			Small Computer Serial Interface (SCSI) devices
sf 			soc+ or socal Fiber Channel Arbitrated Loop (FCAL)
soc 			SPARC Storage Array (SSA) controllers
socal 			Serial optical controllers for FCAL (soc+)

/sbus@1f,0/esp@0,3000/sd@2,0:a
represents a slice of a SCSI disk drive on a SPARC system. It is interpreted from left to right as a device attached to the sbus with a main system bus address of 1f,0; an esp device, a SCSI bus attached at sbus slot 0, offset 3000; and an sd device with a SCSI bus target of 2, a logical unit of 0, and an argument of a, which represents slice a of the disk. 

# iostat -En			provide HW details for disks

/etc/path_to_inst		lists all devices that are installed during system boot


@SOLARIS: network, net status, link, speed, duplex, static ip, dhcp, hostname
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
solaris 11 using manual configuration:
# svcadm disable nwam
# netadm enable -p ncp DefaultFixed
# ipadm create-ip net0
# ipadm create-addr -T static -a 10.0.2.18/24 net0/v4static
# route -p add default 192.168.100.1
# route -p show

switch back to automatic configuratio:
# netadm enable -p ncp Automatic

solaris 11 setting up dns manualy:
# svccfg
svc:> select name-service/switch
svc:/system/name-service/switch> setprop config/host = astring: "files dns"
svc:/system/name-service/switch> setprop config/ipnodes = astring: "files dns"
svc:/system/name-service/switch> select name-service/switch:default
svc:/system/name-service/switch:default> refresh
svc:/system/name-service/switch:default> validate
# svccfg
svc:> select nis/domain
svc:/network/nis/domain> setprop config/domainname = "itdg.nbg"
svc:/network/nis/domain> select nis/domain:default
svc:/network/nis/domain:default> refresh
svc:/network/nis/domain:default> validate
# svccfg
svc:> select dns/client
svc:/network/dns/client> setprop config/nameserver=net_address: ( 2001:4dd0:fd4e:ff01::1 2001:4dd0:fd4e:ff02::1 )
svc:/network/dns/client> select dns/client:default
svc:/network/dns/client:default> refresh
svc:/network/dns/client:default> validate
svc:/network/dns/client:default> exit
# svcadm enable dns/client

solaris 11 initial config using 'network auto-magik' (nwam) profiles:
# netcfg create ncp datacenter						creates a profile
# netcfg
netcfg> select ncp datacenter						configure the created profile
netcfg:ncp:datacenter> create ncu phys net0
Created ncu 'net0'.  Walking properties ...
activation-mode (manual) [manual|prioritized]> 
link-mac-addr> 
link-autopush> 
link-mtu> 
netcfg:ncp:datacenter:ncu:net0> end
Committed changes
netcfg:ncp:datacenter> create ncu ip net0
Created ncu 'net0'.  Walking properties ...
ip-version (ipv4,ipv6) [ipv4|ipv6]> ipv4
ipv4-addrsrc (dhcp) [dhcp|static]> static
ipv4-addr> 192.168.1.53
ipv4-default-route> 192.168.1.1
netcfg:ncp:datacenter:ncu:net0> end
Committed changes
netcfg:ncp:datacenter> exit
# netadm enable -p ncp datacenter					enable the created profile

# netcfg								creating a location profile
netcfg> create loc datacenter
Created loc 'datacenter'.  Walking properties ...
activation-mode (manual) [manual|conditional-any|conditional-all]> 
nameservices (dns) [dns|files|nis|ldap]> 
nameservices-config-file ("/etc/nsswitch.dns")> 
dns-nameservice-configsrc (dhcp) [manual|dhcp]> manual
dns-nameservice-domain> 
dns-nameservice-servers> 192.168.1.1
dns-nameservice-search> yourdomain.com
dns-nameservice-sortlist> 
dns-nameservice-options> 
nfsv4-domain> 
ipfilter-config-file> 
ipfilter-v6-config-file> 
ipnat-config-file> 
ippool-config-file> 
ike-config-file> 
ipsecpolicy-config-file> 
netcfg:loc:datacenter> end
Committed changes
netcfg> end
# netadm enable -p loc datacenter					enable created profile
# netadm list -x							display actual network infos
# netadm show-events -v
# netadm disable -p ncu -c ip net0					disable ip of interface net0

change IP in location profile
chrigi@cheesy:~$ netcfg 
netcfg> select ncp vm
netcfg:ncp:vm> select ncu ip net0
netcfg:ncp:vm:ncu:net0> list
ncu:net0
	type            	interface
	class           	ip
	parent          	"vm"
	enabled         	true
	ip-version      	ipv4
	ipv4-addrsrc    	dhcp
	ipv6-addrsrc    	dhcp,autoconf
netcfg:ncp:vm:ncu:net0> set ipv4-addrsrc=static
netcfg:ncp:vm:ncu:net0> set ipv4-addr=192.168.0.105/24
netcfg:ncp:vm:ncu:net0> list
ncu:net0
	type            	interface
	class           	ip
	parent          	"vm"
	enabled         	true
	ip-version      	ipv4
	ipv4-addrsrc    	static
	ipv4-addr       	"192.168.0.105/24"
	ipv6-addrsrc    	dhcp,autoconf

set it back to dhcp:
netcfg:ncp:vm:ncu:net0> clear ipv4-addr
netcfg:ncp:vm:ncu:net0> set ipv4-addrsrc=dhcp
netcfg:ncp:vm:ncu:net0> list
ncu:net0
	type            	interface
	class           	ip
	parent          	"vm"
	enabled         	true
	ip-version      	ipv4
	ipv4-addrsrc    	dhcp
	ipv6-addrsrc    	dhcp,autoconf
netcfg:ncp:vm:ncu:net0> end
Committed changes
netcfg:ncp:vm> end
netcfg> end


solaris 11 set hostname:
# svccfg -s system/identity:node
svc:/system/identity:node> setprop config/nodename = host.domain.com
svc:/system/identity:node> refresh
svc:/system/identity:node> end
# svcadm restart system/identity:node

S11# dlamd show-phys
S11# dladm show-vnic
S11# ipadm show-if [-o all]
S11# ipadm show-addr							displays the configured IPs
S11# ipadm delete-ip <interfaceName>					delete ip interface if its only temporary
S11# ipadm create-ip <interfaceName>
S11# ipadm create-addr -T [static/dhcp] [-a <IP/mask>] <interfaceName>/<anything>
# dladm show-link
# dladm show-dev							displays available interfaces
S11# dladm create-vnic -l <physical> <vnicName>				creates a new virtual nic
S11# ipadm create-ip <vnicName>						creates a virtual ip on <vnicName>
# cat /etc/path_to_inst							look for notorious network devicenames (bge, e1000, hme, eth ...)
# ifconfig <interface> down unplumb					takes the interface offline
# ifconfig <interface> plumb up						only if its not already plumbed
# ifconfig <interface>:1 plumb <ipaddress>/<netmask> up			creates virtual interface
# ifconfig <interface> <ipaddress> netmask [+] <netmask>

configure interface:
create /etc/hostname.<interface> insert into this file: 		do not replace hostname with its apropriate hostname!
	hostname							choose anything, this is just used to find apropriate IP in /etc/hosts
insert ipaddress and hostname in /etc/inet/hosts and /etc/inet/ipnodes (for ipv6 use this file only)
add line to /etc/netmasks
	<net-id>	<netmask>
add router to /etc/defaultrouter
	<routerIP>
to configure dhcp create a file /etc/dhcp.<interface> insert into this file:
	<hostname>							replace hostname with its apropriate hostname!
# svcadm restart network/physical

setting hostname
	/etc/nodename			# configure the hostname in here
	if dhcp is resetting your hostname automatically use this script:
#!/sbin/sh
HOSTNAME=`cat /etc/nodename`
echo "Setting hostname to $HOSTNAME...  \c"
uname -S $HOSTNAME
echo "Done."
copy script to /etc/init.d/set_hostname
# ln -s /etc/init.d/set_hostname /etc/rc2.d/S70set_hostname

other important network files:
	/etc/netmasks
	/etc/defaultrouter

setup speed and link mode (for bge interfaces only):
to change at system runtime use the following script:
#!/sbin/sh
# Force bge1 to 100fdx autoneg off
ndd -set /dev/bge1 adv_1000fdx_cap 0
ndd -set /dev/bge1 adv_1000hdx_cap 0
ndd -set /dev/bge1 adv_100fdx_cap 1
ndd -set /dev/bge1 adv_100hdx_cap 0
ndd -set /dev/bge1 adv_10fdx_cap 0
ndd -set /dev/bge1 adv_10hdx_cap 0
ndd -set /dev/bge1 adv_autoneg_cap 0

to change permanently, insert in the file: /platform/sun4u/kernel/drv/bge.conf
the following line:
adv_autoneg_cap=0 adv_1000fdx_cap=0 adv_1000hdx_cap=0 adv_100fdx_cap=1 adv_100hdx_cap=0 adv_10fdx_cap=0 adv_10hdx_cap=0;

useful networking commands
# netstat -f inet				lists all open tcp connections
# snoop [-v tcp port 23] -o <outputFile>	network sniffing tool

vlan tagged interface
# ifconfig <interface> plumb			<interface> = <interfaceName> <vlanNumber> * 10'000 + <interfaceNumber>
						example: hme0 in VLAN 3 = hme30000
# ifconfig <interface> <ipAddress> netmask <netmask> up


@SOLARIS: network health, hardware health
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# dladm show-dev			show interfaces
# dladm show-dev -s			show interface all time statistics

hardware
# fmadm faulty				lists any issues on hardware devices


@SOLARIS: router
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# routeadm
# routeadm -e ipv4-forwarding		enables IPv4 forwarding
# routeadm -e ipv4-routing		enables IPv4 routing
# routeadm -l route			lists all parameters for routing daemon
# routeadm -m route key=value		modifies parameter "key" to "value"
default gw on "client"
# route -p add default 192.168.100.1

if local network (192.168.7.0/24) should see public network (0.0.0.0/32):
note that vphys0 is the interface connected to the public network.
# vi /etc/ipf/ipnat.conf
map vphys0 192.168.7.0/24 -> 0/32 proxy port ftp ftp/tcp
map vphys0 192.168.7.0/24 -> 0/32

# svcadm enable ipfilter


@SOLARIS: port forwarding
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
see config examples in: /usr/share/ipfilter/examples/
# vi /etc/ipf/ipnat.conf
rdr vphys0 172.16.65.246 port 10021 -> 192.168.7.1 port 22 tcp			creates a redirect

# svcadm enable ipfilter
# ipnat -f /etc/ipf/ipnat.conf

# ipnat -l
List of active MAP/Redirect filters:
rdr vphys0 172.16.65.246/32 port 10021 -> 192.168.7.1 port 22 tcp

List of active sessions:
RDR 192.168.7.1     22    <- -> 172.16.65.246   10021 [172.16.192.161 60062]


@SOLARIS: dns
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
name server cache: nscd (/etc/nscd.conf)
svc:/system/name-service-cache:default


@SOLARIS: security
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# last						list of last logins; reads the file /var/adm/wtmpx
# cat /var/adm/sulog				lists all root access; config file /etc/default/su
to log failed login attempts:
# touch /var/adm/loginlog && chmod 640 /var/adm/loginlog	parameters can be set in /etc/default/login
/etc/ftpd/*					files for ftp security
/etc/pam.conf					comment out lines containing rhosts_auth.so.1; will force password authentication for rlogin
# chmod 4nnn <file>				sets the setuid permission on <file>; the file will be executed as owner instead of the one who start the execution
						 <file has to be a binary not a script
# chmod 2nnn <file>             		sets the setgid permission on <file>
# chmod 1nnn <file>             		sets the sticky bit on <file>; file can only be deleted from its owner

auditd, basic security module (bsm):
# praudit [-x] /var/audit/<auditFile>		displays content of audit file [xml output]
# auditreduce -c lo -O lo.summary		reduces the audit logs to login/logout (lo) entries and save the output in <fromDate>.<toDate>.lo.summary. Use praudit to view its content
# auditreduce -m 113						select specific event 113 (system booted)
# auditreduce -z <zoneName>					select records for zone <zoneName>
# auditreduce -o file=/etc/passwd,/etc/default -O filechg	find audit records for specific files, generates a *filechg file
# praudit *filechg						review the generated *filechg file



@SOLARIS: driver, tcp, ndd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ndd -get /dev/tcp \?				get all the available TCP parameters
# ndd -get /dev/tcp <parameterName>		get the value of <parameterName>
# ndd -set /dev/tcp <parameterName> <value>	set the <parameterName> to <value>

find driver which is used for device:
# ls -al /dev | grep <yourDevice>	locate the device in the /devices tree
# ls -al /devices/<yourDevicePath>	lookup for device's major number
# grep <majorNumber> /etc/path_to_major	returns the driver name used for devices with major number <majorNumber>


@SOLARIS: log, logfiles
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/var/log/syslog
/var/adm/messages
/var/sadm/system/logs


@SOLARIS: zip, unzip, tar
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# gunzip -c <archive.tar.gz> | tar xf -		entpackt das tar.gz archive in den aktuellen Ordner


@SOLARIS: xserver, boot without x, no desktop at boot, graphical
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# svcadm disable cde-login	disable graphical desktop
# dtconfig -d			disable desktop autostart feature (legacy)
# dtconfig -e			enable desktop autostart feature (legacy)


@SOLARIS: home, /home directory read only
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Falls keine zentralisierten Home-dirs verwendet werden, kann der automount der Home-dirs ausgeschaltete werden.
Das /home kann dann auf 755 gesetzt werden
# svcadm disable autofs


@SOLARIS: multipathing, powerpath, mpxio, san, SAN, hba
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
relevant files: /kernel/drv/fp.conf
# mpathadm list lu				shows LUNs
# mpathadm show lu /dev/rdsk/<devname>		show LUN details
# luxadm -e port				shows connected FC ports
# luxadm -e rdls /dev/cfg/c1			shows error statistics on c1 HBA
# cfgadm -lv					show HBAs
# cfgadm -al -o show_SCSI_LUN			show LUNs
# fcinfo hba-port				show details on HBA
# fcinfo remote-port -ls -p <HBAPortWWN>	shows the presented LUNs
# luxadm probe					show LUNs

multipathing with emc powerpath
# powermt display dev=all		zeigt alle LUNs mit ihren Pfaden an (Powerpath Command)

add a new lun
# devfsadm
# powermt config
# powermt save

remove a lun:
# powermt remove dev=<devName>
# powermt release (linux only)
	delete devices in /dev/dsk & /dev/rdsk
	cleanup entries in /etc/path_to_inst

on cluster export mappings and import on ohter nodes
# emcpadm export_mappings -x -f /etc/pp_map.20111026.xml
# emcpadm import_mappings -v -x -f /etc/pp_map.20111026.xml
to map the device in a zone it needs to be listed in /etc/devlink.tab. For device emcpower37a add the following lines:
type=ddi_pseudo;name=emcp;addr=37;minor=a,blk   dsk/emcpower\A0\M1
type=ddi_pseudo;name=emcp;addr=37;minor=a,raw   rdsk/emcpower\A0\M1


configuring load-balancing: /kernel/drv/scsi_vhci.conf

activate mpxio with automatic reboot
# stmsboot -e
to activate multipathing only on fibre devices run
# stmsboot -D fp -e

Get HBA infos
# for i in `cfgadm |grep fc-fabric|awk '{print $1}'`;do
  dev="`cfgadm -lv $i|grep devices |awk '{print $NF}'`"
  wwn="`luxadm -e dump_map $dev |grep 'Host Bus'|awk '{print $4}'`"
  echo "$i: $wwn"
  done
activate HBAs
# cfgadm -c configure cx
scan LUNs, list available SAN devices
# luxadm probe
reconfig reboot
# sync
# reboot -- -r		# -- submits -r to the boot command
show LUNs
# mpathadm list lu				shows all luns
# mpathadm show lu <device>		shows more details
# luxadm display <Device>


config scenario 2 (not verified yet 09.05.11)
to turn on Solaris built-in mpxio for all devices (probably also for internal devices), edit the file /kernel/drv/fp.conf: mpxio-disable="no";
otherwise turn on mpxio only for selected devices; edit the file /kernel/drv/fp.conf:
and do a reconfiguration boot (reboot -- -r)


@SOLARIS: system config, system setup
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# sys-unconfig		resets the whole system config


@SOLARIS: disk, fs, filesystem, extend
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# disks			nach neuer IDE Disk suchen
# drvconfig		nach neuen Devices suchen
# devfsadm		this is the actual command to scan for new disks
same new command: # devfsadm		config utility for the /dev namespace
# format		disk labeln
	[>fdisk		create fdisk partition necessary only for x86 systems]
	>label		disklabel schreiben
	>volname	Bezeichnung des Volumes
	>verify		anzeige des disklabel
	>partition	changing slices
			for deletion just choose 'unassigned' and size 0
	>label		write changed label to the disk
/etc/format.dat		contains default labels
# prtvtoc <dev>		prints out the disklabel
prtvtoc: /dev/rdsk/emcpower38a: Unable to read Disk geometry errno = 0x16
	# format -e /dev/rdsk/emcpower38a
	format> analyze
	analyze> setup		adjust settings or leave defaults
	analyze> write		ATTENTION all data will be erased
	
# fmthard -s <datafile> <dev>	writes the output of prtvtoc saved in <datafile> to device <dev>
	

@SOLARIS: ufs creating
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# newfs -v /dev/rdsk/c0t0d0s0
# newfs -N /dev/rdsk/c0t0d0s0		just prints out the superblocks (-N = noexec)
# fsck /dev/rdsk/c0t0d0s0		verify the created filesystem
# fstyp [-v] /dev/rdsk/c0t0d0s0		guess the fstype, just reads the first block, means no info of the health of fs


@SOLARIS: zfs dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zpool list [-r] [<poolname> | <fsname>]			zeigt alle zfs pools an [recursively]
# zpool status <poolname>					zeigt details des pools
# zpool create <poolname> [mirror] <dev> [<dev>]		creates a pool, out of <dev> or [mirror]
# zpool destroy <poolname>					löscht einen pool
# zpool add <poolname> [mirror] <dev> [<dev>]			adds a disk [mirror] to pool
	ATTENTION: youre not able to remove a disk from an unmirrored pool
# zpool import							lists the available zpools
# zpool import <zpoolName>					imports the zpool (mounts the datasets)
Corrupt label; wrong magic number; and thus the disks in the pool are listed as UNAVAIL; try
# zpool clear <zpoolName>					clears errors on zpool disks
# zpool scrub <zpoolName>					'resyncs' a mirrored pool
error: could not verify zfs dataset <datasetName>: dataset does not exist
resolution: zpool is probably not imported. List available, unimported zpool with # zpool import

# zfs list							zeigt alle zfs filesysteme an
# zfs create <poolname>/<fsname>				erstellt ein fs
# zfs create -V <size> <poolname>/<volName>			creates a volume rather than a fs, available in /dev/zvol/[r]dsk/<poolname>/<volName>
# zfs destroy <poolname>/<fsname>				löscht ein fs
# zfs set mountpoint=/<mnt> <poolname>[/<fsname>]		passt den mountpoint an
# zfs set quota=<valueMGT> <poolname>/<fsname>			sets a limit on <poolname>/<fsname>
# zfs set reservations=<valueMGT> <poolname>/<fsname>		<poolname>/<fsname> has <valueMGT> for sure
# zfs set recordsize=8k <poolname>                      	set this if oracle dbf files will be stored in this pool, performanc issue!
# zfs mount <poolname>/<fsname>					mountet das fs
# zfs umount <poolname>/<fsname>				umountet das fs
# zfs mount -a							mounts all filesystems
# zfs get [-r] all <poolname>[/<fsname>]			shows all infos for <poolname>/<fsname> [recursively]
# zfs snapshot <poolname>/<fsname>@<snapshotName>		creates a snapshot of <poolname>/<fsname>
	snapshot is mounted under: <mountpoint>/.zfs/snapshot/<snapshotName> (read only)
# zfs rollback <poolname>/<fsname>@<snapshotName>		resets <poolname>/<fsname> to its state at <snapshotName>
# zfs clone <poolname>/<fsname>@<snapshotName> <poolname>/<cloneName>	clone is r/w image of <snapshotName>
	<snapshotName> cannot be deleted till <cloneName> is deleted or promoted
# zfs send <poolname>/<fsname>@<snapshotName> > <file>			sends datastructure of <snapshotName> to <file>
# zfs send <poolname>/<fsname>@<snapshotName> | gzip > <file.gz>	sends datastructure of <snapshotName> to compressed gzip <file>
# zfs receive <poolname>/<fsname>					receives datastructure
# gzip -cd <file.gz> | zfs receive [-F] <poolname>/<fsname>		receives datastructure out of <file.gz>, -F overwrites existing <poolname>/<fsname>
# zfs send <poolname>/<fsname>@<snapshotName> | ssh <host> zfs receive <poolname>/<fsname>	sends and receives data over network
refere to zone section for zfs commands related to zones
# zfs send pool/fs@a | ssh host zfs receive [-F] poolB/received/fs@a	[-F] overwrites existing fs at destination

read disklabel
# zdb -l /dev/rdsk/c0d0s0


@SOLARIS: boot environments	(solaris 11 only)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# beadm list			lists all BE's
# beadm create <name>		creates a new BE
# beadm activate <name>		activates BE <name>
# reboot			server will boot in the activated BE
# beadm destroy <name>		destroys BE <name>


@SOLARIS: zones, containers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zonename				displays actual zone
# zoneadm list -cv
# zonecfg -z <zoneName>			edits configfile: /etc/zones/<zoneName>.xml
# ifconfig <ifName> addif <ipAddress>/<netmask> zone <zoneName> up	adds an additional interface to zone <zoneName>
# ifconfig <ifName>:X unplumb		removes interface <ifName>:X from zone
# zlogin <zoneName> reboot		is preferred before zoneadm -z <zoneName> reboot
error: zoneadm: zone <zoneName>: must be installed before boot
resolution: # zoneadm -z <zoneName> attach
error: These patches installed on the source system are inconsistent with this system:
resolution: # zoneadm -z <zoneName> attach -u		this will upgrade the local zone to the level of the global zone

Create a brandnew zone
# zonecfg -z just
just: No such zone configured
Use 'create' to begin configuring a new zone.
zonecfg:just> create			copies /etc/zones/SUNWdefaults.xml (sparse zones)  to /etc/zones/<zoneName>.xml (~100mb)
					mounts /usr /sbin /lib /platform as loopback filesystems from global root
zonecfg:just> create -b			creates full rooted zone; /usr /sbin /lib /platform will be copied to the zone (~5gb)
zonecfg:just> set zonepath=/opt/zones/just
zonecfg:just> info
zonecfg:just> verify
zonecfg:just> commit
zonecfg:just> exit
# mkdir /opt/zones/just
# chmod 700 /opt/zones/just
# zoneadm -z just install
# zoneadm -z just boot
# zlogin -C just		after installation -C starts console mode, to complete configuration (escape char should be ~. or ~ <blank> . or ~~.)
# zoneadm list -iv
  ID NAME             STATUS     PATH                           BRAND    IP
   0 global           running    /                              native   shared
   1 just             running    /opt/zones/just                native   shared
# zlogin just
# zonecfg -z just								S.254 in manual
zonecfg:just> set bootargs="-m verbose"
zonecfg:just> add net
zonecfg:just:net> set address=192.168.23.11/24
zonecfg:just:net> set physical=e1000g1
zonecfg:just:net> set defrouter=192.168.23.1
zonecfg:just:net> end
zonecfg:just> add device				if device is not listed in zone see section san, powerpath
zonecfg:just:device> set match=/dev/rdsk/emcpower37a
zonecfg:just:device> end
zonecfg:just> add device
zonecfg:just:device> set match=/dev/dsk/emcpower37a
zonecfg:just:device> end
zonecfg:just> add fs
zonecfg:just:fs> set type=zfs
zonecfg:just:fs> set special=<zpool>/<fsSet>		path related to global zone, set mountpoint to 'legacy' in global zone for this fs, do not use a leading /
zonecfg:just:fs> set dir=<mountpoint>			mountpoint in zone
zonecfg:just:fs> end
zonecfg:just> add dataset				fs will be managable from the zone, set mountpoint to 'none' in global zone for this fs
zonecfg:just:dataset> set name=<zpool>/<fsSet>
zonecfg:just:dataset> end
zonecfg:just> commit					verifies and saves the config in /etc/zones/<zoneName>.xml
zonecfg:just> exit
# zoneadm -z just reboot
# zonecfg -z just info		details about the zone 'just'

add device manually to the zone:
# zfs create -V <size> <pool>/<volname>			creates zfs volume
# ll /dev/zvol/*dsk					lists major minor number of created volume
# mknod /path/to/zone/dev/dsk b <majorNr> <minorNr>	creates block devicefile for zone
# mknod /path/to/zone/dev/rdsk c <majorNr> <minorNr>	creates char devicefile for zone

delete a zone
# zoneadm -z mutrux uninstall [-F]			-F: force
# zonecfg -z mutrux delete [-F]				-F: force

zfs snapshots
# zfs snapshot -r fzones006/hummingbird@<snapshotName>		create a recursive snapshot for zone 'fzones006/hummingbird'
# zfs list -r -t snapshot fzones006/hummingbird			lists available snapshot for zone 'fzones006/hummingbird'
# zfs rollback fzones006/hummingbird@<snapshotName>		rollback the zone 'fzones006/hummingbird' to the snapshot <snapshotName> 
# zfs destroy -r fzones006/hummingbird/u00@<snapshotName>	delete a snapshot
# zfs rename fzones006/hummingbird@<snapshotName> fzones006/hummingbird@<snapshotNewName>

clone a zfs filesystem
# zfs snapshow <poolName>/<filesystemName>@<snapshotName>
# zfs clone <poolName>/<filesystemName>@<snapshotName> <newPoolName>/<newFilesystemName>


@SOLARIS: svm, solaris volume manager, sds, solstice disk suite
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# metadb -ac 3 -f </dev/rdsk/cXtXd0sX>			adds 3 metadbs initially, needs at least 3 because of quorum in case of one coruupted metadb
	 -i						reads infos
# metastat                                              shows mirrors with submirrors
# metastat -c                                           shows mirrors with submirrors in a compact view
# metainit <dName> <numStripes> <width> <component> [<width> <component>]
							<dName>		devicename in /dev/md/
							<numStripes>	1 = no concat; >1 = concat; concat:  add data to second disk if first is full
							<width>		1 = no stripe; >1 = stripe; stripe: number of <component>
							<component>	devicefile i.e. cXtXd0sX
example create mirror:
# metainit d11 1 1 c0t0d0s0				create first mirrordisk
# metainit d12 1 1 c0t1d0s0				create second mirrordisk
# metainit d10 -m d11					create mirror
# metattach d10 d12					attach the second mirrordisk to the mirror
# metadetach d10 d11					detachs the mirrordisk d11 from mirror d10
# metaclear d10						deletes mirror d10

# metainit <partitionName> -p <device> <size>           creates a soft partition. example: metainit d601 -p d60 100m
# metareplace -e <mirror> <failedSlice>                 enables a slice and start synchronization example: metareplace -e d60 /dev/dsk/c0t1d0s3

replacement procedure for a failed metadb disk:
# metadb						display the metadb locations (uppercase W in the flags section means write errors on the disk)
# metadb -d c0t0d0s7					deletes the metadb on given (failed) slice
# cfgadm -al						lists all devices
# cfgadm -c unconfigure c0::dsk/c0t0d0			unconfigure the failed disk
replace the disk physically
# cfgadm -c configure c0::dsk/c0t0d0			configures the newly inserted disk
# devfsadm						creates the devicetree
if the new disk cannot be formatted with format command may a reconfiguration reboot is required (that was the case on Solaris10 Jan 2013)
# prtvtoc /dev/rdsk/c0t1d0s0 | fmthard -s - /dev/rdsk/c0t0d0s2		copy the disklabel from the working disk (c0t1d0) to the new disk (c0t0d0)
# metadb -a -c 3 c0t0d0s7				recreate the metadb on new disk
# metareplace -e d10 c0t0d0s0				resync the meta mirrors (d10 is the mirror name, c0t0d0s0 the slice of new disk to sync)


@SOLARIS: swap, /tmp vergrössern, expand, extend, resize
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
swapsize can only be changed on global zone!
# swap -lh                                              swapfiles anzeigen
# mkfile <size> /path/to/file			        erstellt ein file mit der groesse size
# swap -a /path/to/file                         	tell swap to use created file as swap
# swap -a /dev/dsk/c2t0d0s2                     	use a raw dev as swap

SOLARIS11:
add another swap file:
# zfs create -V 12G rpool/swap2
# swap -a /dev/zvol/dsk/rpool/swap2


@SOLARIS: memory usage, swap, swapping
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# vmstat <intervall>
Example (system under heavy load, oracle linking process):
[root@jimmy /]# vmstat 2
 kthr      memory            page                               disk          faults      cpu
 r b w   swap  free  re  mf pi  po       fr   de sr  cd cd f0 s0  in  sy  cs   us sy id
 0 1 66 775360 9412  15 258 177 1079 1859 0 2474 25 64 0  0  666 299 11112 1  15 83
 1 1 66 773668 9184   7 487 218 1272 2594 0 5686 26 72 0  0  686 288 11906 2  18 80
 If page/sr (page scan rate) exceeds 200 pages per second for an extended time, your system may be running short of physical memory.
Example (system idle):
[root@jimmy /]# vmstat 2
 kthr      memory            page            disk          faults      cpu
 r b w   swap  free  re  mf pi po fr de sr cd cd f0 s0   in   sy   cs us sy id
 0 0 40 750112 10000  0  18  7  0  0  0  0  4  0  0  0  426  397 1346  0  2 98
 0 0 40 750096 10024  3   3  0  0  0  0  0  0  0  0  0  416  368  548  0  1 98

# iostat -dx			disk io more verbose
# zpool iostat <poolName> <interval>
# iostat -xPnce                 provides information on swap disk activity
# iostat -xnce                  not only for swap disks
# prtconf | grep -i mem         shows physical memory
# echo ::memstat | mdb -k       shows used/ free memory, vmstat also shows free mem in kb


@SOLARIS: sort dinge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# sort +1 -2 <file>		sorts file on the 2. column
# sort -n +1 -2 <file>		sorts file on the 2. column numerically


@SOLARIS: processes, core files, crash dumps
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ps -efl | sort +9nr	most mem consuming process on top (column SZ)
# ps -efl | sort  +13r	most cpu time consuming nearly on top :)
# ps -efZ		lists also the zone which runs the process
# prstat [-a]		periodically updated infos equal to top; [-a] all info
# pstop <pid>		stops process
# prtree <pid>		process tree

core files:
if process crash, system creates core file in process' working dir
/etc/coreadm.conf	settings about core behaviour
# coreadm

kernel dumps, crash dumps:
/var/crash/<hostname>/		contains crash dumps
# savecore
# dumpadm			administer crash dump parameters
# mdb				analyze core dumps


@SOLARIS: performance
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cpu
# prstat				equal to top
disk
# iostat -xnmpz  			disk i/o activity (look especially on %b: %busy svc_t: service time)
# sar -d [5] [2]			disk activity
for io per process use iotop and iosnoop out of the dtrace toolkit 
memory
# vmstat 2				virtual memory statistics (watch for swapping and cpu activity)
network
# netstat -i				check network for collisions, In- or Output errors
# netstat -a				there should not be to much FIN_WAIT
# netstat -I <nic>			reports throughput in packets (see ifconfig -a: MTU is packetsize in bytes)
# sar -n DEV				network statistics
# sar -n DEV -f /var/log/sa/saXX	network statistics from day XX


@SOLARIS: cpu info
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# psrinfo [-pv]
# kstat -m cpu_info


@SOLARIS: Find Serial Number of an M4000, serial number
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# eeprom			look for ChassisSerialNumber and change OBP parameters at system runtime
# eeprom <parameter>=<value>	change a OBP parameter
# sneep				requires SUNWsneep


@SOLARIS: firewall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# svcs ipfilter
# svcadm disable ipfilter


@SOLARIS: tcpwrapper issue (was a problem with data protector)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ldd </path/to/executable>			if libwrap.so is in the list, then you have to take care of
# mv /etc/hosts.deny /etc/no_hosts.deny		this is just a workaround (switch off tcp wrapper)
to fix it add the following line to /etc/hosts.allow
inet:<servernameFullQualified1>,<servernameFullQualified2>,...				replace inet with the apropriate executable


@SOLARIS: ok prompt, init states, obp, OPB, openbootprompt
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SPARC display: OBP: STOP	-> server at ok prompt
# prtconf -V			OBP Version
# shutdown -g 0			-> brings solaris to single user mode immediately (0 seconds delay)
# reboot -- -r			-- submits -r to the boot command
# halt				-> brings solaris to ok prompt
{0} ok banner			prints mem info, system hardware (servertype), MAC address, XSCF version
{0} ok devalias			prints devices
{0} ok printenv			lists environment settings
				adjust these variables from OS with: # eeprom boot-device=disk
{0} ok printenv boot-device	display configured boot device
{0} ok setenv boot-device disk		sets the default boot device
{0} ok boot cdrom		boots from cdrom
{0} ok boot cdrom -s		boots from cdrom into single user mode
{0} ok boot -F failsafe		failsafe boot with extended logging
{0} ok probe-scsi-all		lists all SCSI disks (verified on T3)
{0} ok cd /pci@1,700000/SUNW,emlxs@0
{0} ok .properties		lists details on above device

/a/platform/i86pc/boot_archive
{1} boot -m verbose		from single user boot system more chatty


@SOLARIS: XSCF, xscf
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
configuring XSCF: /usr/sbin/FJSVmadm/madmin
XSCF> console -d 0 -y		connects to console domain 0
To switch from the domain console to the XSCF Shell, press the Enter, # (default escape character), and . (period) keys OR
press ~ and . (tested on TTC Primeower with macbook)
XSCF> showstatus		shows system status
XSCF> showenvironment
XSCF> showdomainstatus 		-a: all domains -d <id>: domain <id>
XSCF> poweroff -d <id>		tries an OS shutdown; [-f] immediate power off
XSCF> showlogs power

hardware analytics:
XSCF> showhardconf
XSCF> showlogs error
XSCF> showlogs monitor
XSCF> fmdump -v

software version:
XSCF> version -c xcp


@SOLARIS: repair boot archive
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{0} ok boot cdrom -s				OR boot -F failsafe
# mount /dev/dsk/c0t0d0s0 /a			mount the root filesystem
# rm -f /a/platform/`uname -i`/boot_archive	remove any existing boot archive
# /usr/sbin/bootadm update +%d_%b_%Y).flar
examples:
exact copy of the existing system:
# flarcreate -n <archiveName> -c <archiveFile>
exact copy but backwards compatible (worked to migrate a solaris 10 into a zone on solaris 11):
# flarcreate -L cpio -n <archiveName> -c <archiveFile>
same as above but without checking the archive size (faster!)
# flarcreate -S -L cpio -n <archiveName> -c <archiveFile>

splits the flar into its different files (use separat folder!)
# flar split <archive.flar>
decompress archive data
# mv archive archive.Z
# uncompress archive.Z
# cat archive | cpio -ivt
# cpio -ivdm etc/inet/hosts < archive		get only one specific file out of the archive (mind the missing / at etc/inet/hosts)

to verify the archive:
cd /Backup/flar
flar info -l f_archive_$(uname -n)_$(date +%d_%b_%Y).flar > f_archive__$(uname -n)_$(date +%d_%b_%Y).list


@SOLARIS: liveupgrade
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lucreate [-c <nameExistingBootEnv>] -n <nameNewBootEnv> -p <zpool>
	ERROR: ZFS pool <poolName> does not support boot environments		relabel your disk to SMI (EFI labeled disk are not bootable)
# lustatus
# luupgrade -n <name> -u -s <locationOfMedia>		upgrades to a higher solaris release
# luupgrade -n <name> -t -s <locationOfPatch> <patchNr>	OR
# patchadd -R <locationNewBootEnvironment> <patchNr>
# luactivate <name>
# init 6						do not use reboot or shutdown -r
# ludelete -n <name> [-f]				deletes a boot environment


@SOLARIS: nfs server, nfs client
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
to run NFS client:
# svcadm enable /network/rpc/bind
# svcadm enable /network/nfs/status
to run NFS server additionally start these services:
# svcadm enable /network/nfs/nlockmgr
# svcadm enable /network/nfs/server
# share -F nfs		# displays the shared directories
# share -F nfs -o anon=0,root=<nfsServerIP> <DirToShare>
# share -F nfs -o rw /shareDir
/etc/dfs/sharetab	# replaces /etc/exports
/etc/dfs/dfstab		# filesystems which should be mounted at boottime
	share -o ro,anon=0 /export/config
if nfs share is mounted as user nobody and thus readonly check if bind daemon is running
# shareall		shares all shares mentioned in /etc/dfs/dfstab
# mount -F nfs <nfsServerIp>:/<nfsShareName> /<mountPoint>

Solaris 11: nfs server
# svcadm enable network/nfs/server	starts nfs server
# sharectl get nfs			display nfs server properties
# zfs create -o dedup=on dinge10k/flars	
# zfs set sharenfs=on dinge10k/flars	shares a directory
# share -F nfs -o rw,nosuid,root=liechtenstein.ttc.trivadis.com /dinge10k/flars
# share -F nfs				displays all shared directories
# unshare -F nfs <shareName>		unshares the directory

@SOLARIS: explorer
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
command to get a full system configuration dump
install the package SUNWexplo
# /opt/SUNWexplo/bin/explorer
output: /opt/SUNWexplo/output


@SOLARIS: avs, availability suite, data replication
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
needs the SUN StorageTek Availability Suite

- add rep hosts und ip in /etc/hosts on both systems
# replication adresses
172.22.187.221  ubems221-r
172.22.187.222  ubems222-r

- add hostnames in /etc/hostname.bge1
# ifconfig bge1 plumb
# dladm show-dev
# fconfig bge1 ubems222-r up
# ifconfig bge1 ubems221-r up
# ifconfig bge1 ubems222-r up
# ping ubems222-r
# ping ubems221-r
# grep rdc /etc/services
- force bitmap mode
- edit /usr/kernel/drv/rdc.conf
rdc_bitmap_mode=1;

- configuring devices
- find out device of pool
# zpool status Stelink_R
	-> c6t60A98000534B4C38645A643435564250d0s0
# dsbitmap -r /dev/rdsk/c6t60A98000534B4C38645A643435564250d0s0
sndradm -e ubems222-r /dev/rdsk/c6t60A98000534B4C38645A643435564250d0s0 /dev/md/rdsk/d501 ubems221-r /dev/rdsk/c6t60A98000534B4C38614A64336C6A3677d0s0 /dev/md/rdsk/d501 ip sync
To Synchronize the Volumes During Update
1. Log in to the primary host rmshost1 as superuser.
2. Unmount the secondary volume. You can keep the primary volume mounted.
3. Synchronize the volumes:
# sndradm -m ubems221-r:/dev/rdsk/c6t60A98000534B4C38614A64336C6A3677d0s0
# sndradm -m ubems221-r:/dev/rdsk/c6t60A98000534B4C38614A64336C6A3677d0s3
# sndradm -m ubems221-r:/dev/rdsk/c6t60A98000534B4C38635A64336D33317Ad0s0
4. Check the synchronization progress
# dsstat -m sndr

# sndradm -p		Display the software status. -P Display detailed software status.
# sndradm -i		Display the software volume set and I/O group names
# sndradm -H		Display the status of the link connecting systems running the software

some basic commands
# dscfgadm -e		enable avs
# dscfgadm -d		disable avs
# svcs | grep nws	check for running avs services
# dscfgadm -i		display info of avs


@SOLARIS: x win, x windows, startx, stopx
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# /usr/dt/bin/dtconfig -d	-> disable the x win system
# /usr/dt/bin/dtconfig -e       -> enable the x win system


@SOLARIS: bashrc, profile
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if you want to configure your personal shell settings you need to add the following line to ~/.profile
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

color prompt:
	PS1='[\[\033[1;31m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\] \w ]# '
	export PS1


@SOLARIS: inetd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
inetd is not configured anymore with /etc/inetd.conf
use inetadm instead.
# inetadm				lists all available inetd services
# inetadm -l <FRMI>			list properties of <FRMI>
# inetadm -m <FRMI> <name>=<value>	modifies <FRMI>'s parameter <name> to <value>

create a new custom inetd service
# vi zforward.inetd
# cat zforward.inetd 
zforward   stream   tcp   nowait   root   /usr/bin/echo   swat
# inetconv -i zforward.inetd
# inetadm -l svc:/network/zforward/tcp:default


@SOLARIS: inetd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
verified on solaris 11
# cp /etc/inet/ntp.client /etc/inet/ntp.conf
# svcadm enable ntp
# svcprop -p config svc:/network/ntp:default		lists all the config properties of ntp


@SOLARIS: ftp server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# vi /etc/passwd
	ftp:x:123:1:Anonymous FTP:/export/home/ftp:/bin/true
# pwconv
# mkdir /export/home/ftp
# chown -R root:other /export/home/ftp
# chmod 555 /export/home/ftp
# mkdir /export/home/ftp/pub
# chmod 777 /export/home/ftp/pub
# vi /etc/ftpd/ftpaccess
	upload /export/home/ftp /pub yes ftp other 0600 nodirs
# inetadm -e ftp
# inetadm | grep ftp


@SOLARIS: loop devices, create virtual raw device
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# dd if=/dev/zero of=/chzones/asm-disks/disk1 bs=1024 count=2097152		creates a 2gb file
# lofiadm -a /chzones/asm-disks/disk1						associate the file with a device /dev/lofi/1
# ls -lL /dev/lofi								read major (147) and minor (1) number
# mknod /chzones/asm-disks/cdisk1 c 147 1					creates a character devicefile

mount iso
# lofiadm -a /full/path/to/iso /dev/lofi/1
# mount -F hsfs -o ro /dev/lofi/1 /mnt
# mount -F hsfs -o ro `lofiadm -a /full/path/to/iso` /mnt		combination of the two commands above


@SOLARIS: release
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# cat /etc/release
# uname -a


@SOLARIS: strace, trace user or system calls, analyze scripts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# truss -topen <command>
# set -o xtrace			displays the command as it is passed from the shell to the kernel
# strings <script>		displays all strings of <script>


@SOLARIS: language setting
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# export LC_ALL=C		sets an solaris installation to english


@SOLARIS: user, rbac
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/default/passwd     set password aging policies
# passwd -x -1 <user>   reset password aging for <user>
# useradd -md <homeDir> -s <shell> -R <roleName> <username>
# roleadd -md <homeDir> -s <shell> -P <profile> <roleName>
# rolemod -K type=normal root		resets root as role back to root as a user

role based access control:
/etc/user_attr
/etc/security/prof_attr
	<profileName>:...:...:...
/etc/security/exec_attr
	<profileName>:...:<command>:uid=0
/etc/user_attr
	<roleName>:type=role;profiles=<profileName>
	<username>:type=normal;roles=<roleName>
/etc/passwd
	<username>:...:/usr/bin/pf[k|c]sh		user with special login shell to execute provided commands
# profiles <username>
# roles <roleName>


@SOLARIS: jumpstart
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
boot-server:	rarp/tftp
		dhcp
config-server:	sysidcfg		contains all infos needed by sysidcfg utility (language, network, etc.)
		rules.ok		who use which profile	
		profile (class)		similar to kickstart.cfg
install-server:	packages/ patches
		flash archives

rules-file syntax:
hostname clientname	[begin script|-]	class file	[finish script|-]
generic example:
any -	-	class_generic	-

test with a VM environment:
# mkdir /export/install
mounted solaris dvd and changed to the Solaris_10/Tools dir
# ./setup_install_server /export/install
# mkdir /export/config
# cp -r /export/install/Solaris_10/Misc/jumpstart_sample/* /export/config
prepared nfs share in /etc/dfs/dfstab:
	share -o ro,anon=0 /export/config
# shareall
# vi /export/config/sysidcfg
network_interface=PRIMARY       {protocol_ipv6= no
                                netmask=255.255.255.0
                                default_route=192.168.55.1}
security_policy=NONE
name_service=NONE
timezone=CET
system_locale=C
timeserver=localhost
root_password=39crpkpII1GGE
# vi /export/config/rules		(uncomment any other entries)
	any - - host_class finish_script
# vi /export/config/host_class
install_type    initial_install
system_type     standalone
partitioning    explicit
metadb c0t0d0s7 size 8192 count 2
metadb c0t1d0s7 size 8192 count 2
filesys mirror:d0 c0t0d0s0 c0t1d0s0 8192 /
filesys mirror:d10 c0t0d0s1 c0t1d0s1 500 swap
filesys mirror:d20 c0t0d0s3 c0t1d0s7 1000 /var
cluster         SUNWCuser
cluster         SUNWCown delete
cluster         SUNWCtltk delete
cluster         SUNWCxgl delete
cluster         SUNWCxil delete
filesys         srvr:/usr/openwin - /usr/openwin ro,intr
# vi /export/config/finish_script
#!/bin/sh
touch /a/noautoshutdown
touch /a/etc/.NFS4inst_state.domain
# chmod 755 /export/config/finish_script
# /export/config/check
# vi /etc/hosts
	192.168.55.65   tmp.trivadis.com        tmp
# vi /etc/ethers			(mac address of the client)
	00:0c:29:2d:ef:65       tmp
# vi /etc/netmaks
	192.168.55.0    255.255.255.0
# ./add_install_client -e 00:0c:29:2d:ef:65 -p chilly:/export/config -c chilly:/export/config -s chilly:/export/install -t chilly:/export/install/boot tmp i86pc
make sure dhcp server is running properly (refer to chapter dhcp server). add the following macro to the dhcp server:
# dhtadm -A -m tmp -d ":BootSrvA=192.168.55.60:BootFile=pxegrub.I86PC.Solaris_10-1:"
	BootFile param may vary, please refer to /tftpboot directory


@SOLARIS: dhcp server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
solaris 11:
# pkg install isc-dhcp
config file: /etc/inet/dhcpd4.conf
lease file: /var/db/isc-dhcp/dhcpd4.leases
# svcadm enable dhcp/server:ipv4

# dhcpconfig -D -r SUNWfiles -p /var/dhcp
	creates config file: /etc/inet/dhcpsvc.conf 
		make sure your interface which should provide dhcp services is listed with an entry:
		INTERFACES=<interfaceName>	i.e.: INTERFACES=e1000g0
	and resource table in /var/dhcp
# dhcpconfig -N <netID> -m <mask> -t <router>				configures an additional network
# pntadm -L								lists the networks wich will be served by dhcp
# pntadm -C <netID>							creates a table for another network
# pntadm -f 01 -A <clientIP> -m <macroName> -s <dhcpServer> <netID>	adds a permanent (-f 01) entry
# dhtadm -A -m <macroName> -d ":<param>=<value>:<param>=<value>:"	adds a macro to /var/dhcp/SUNWfiles1_dhcptab
# dhtadm -P								lists configured macros


@SOLARIS: cluster (3.2)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# cluster status		cluster status verbose



############################################################################
#
# AIX (all commands verified with AIX 5.3)
#
############################################################################

@AIX: iscsi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
check if the necessary software is installed: devices.iSCSI_sw.rte
# lslpp -l | grep iscsi	
check for a proper iscsi name
# smitty -> Devices -> iSCSI -> iSCSI Protocol Device -> Change/ Show Characteristic...
adding a target to: /etc/iscsi/targets
	192.168.1.7     3260      iqn.1986-03.com.ibm.:2145.sahyadri.node1
run scan:
# cfgmgr -v -l iscsi0
now you should be able to see the disk with
# lsdev -c disk


@AIX: san, multipathing, mpio, fc, hba
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lspath
# fcstat <fcsX>		details on fc adapter (get fcsX device name from lsdev)
# lscfg -vl <fcsX>	details on fc adapter (get fcsX device name from lsdev)


@AIX: lvm, logical volumes manager
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lspv			lists physical volumes
# lspv <PVName>		lists details physical volumes
# lsvg			lists volume groups
# lsvg <VGName>		lists details on VG <VGName>
# lsvg -l <VGName>	lists logical volumes in <VGName>


@AIX: devices, list devices, lspci, configuration, hardware scan
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# smitty			similar to yast
# cfgmgr			configure new attached hardware
# lsdev [-c <type>] [-H]	-H prints headers
# lsattr -El <name>		<name> as displayed with lsdev -H


@AIX: patches
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# instfix -i


@AIX: software, packages, installation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lslpp


@AIX: monitoring
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# nmon

@AIX: vio, globalzone, lpar
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
VIO is the 'globalzone' of the aix virtualization framework LPAR.
networking:
# lsdev								list devices
# lsdev -virtual						virtual devices
# lsdev -type adapter						lists all adapters
# lsdev -dev ent0 -vpd						details on adapter ent0
# lstcpip							prints IP config
# lsmap -all -net						list virtual - physical mapping
# netstat -cdlistats | grep -Ei "\(ent|media|link status"	list links on physical ethernet adapters


############################################################################
#
# HP-UX (11)
#
############################################################################

@HPUX: serverinfo
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# model
# machinfo


@HPUX: disks
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# smh (sam on older HPUX)
# ioscan -fnC disk
# diskinfo -v /dev/rdsk/c0t4d0
LVM: uses same syntax as linux
# idisk				partition utility
# insf -e -C disk		create device files
# drd status			dynamic root disk (be in solaris)


@HPUX: filesystems
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# fsadm
# di -h		instead of df -h


@HPUX: san, hba, fc
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ioscan -fnC fc
# fcmsutil /dev/fcd0


@HPUX: memory, swap
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# swapinfo -a


@HPUX: services
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
services are located in: /sbin/init.d
runlevel definitions in: /sbin/rcX.d
activate services in: /etc/rc.config.d/


@HPUX: terminal
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set terminal to xterm
# export TERM=xterm


@HPUX: performance
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# top
# sar
crontab:
# system activity reporter (sar)
0            *    *    *    *    /usr/lib/sa/sa1 600 6 &


@HPUX: network
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
config: /etc/rc.config.d/netconf
# lanscan


@HPUX: packages, software installation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# swlist -l product | grep <package>
# swlist -v -l file


@HPUX: vm, hpvm
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
hpvmcreate 		to create virtual machines
hpvmstatus 		to display status information
hpvmstart and hpvmstop 	to start and stop virtual machines
hpvmmodify 		to modify existing virtual machines
hpvmconsole 		to simulate a hardware console
hpvmmigrate 		to perform on-line or off-line guest migration
hpvmsar 		to show performance information about the running guests.
hpvmsuspend and hpvmresume to suspend and resume virtual machines


############################################################################
#
# OSX	(10.7)
#
############################################################################

# @OSX: docker on osx
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# attach a console to local docker VM (alpine linux)
screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty

# get syslogs (if logging: driver: syslog)
# attach a console to local docker VM
cd /host_docker_app; ln -s /var/log
# from OSX shell:
tail -f ~/Library/Containers/com.docker.docker/Data/log/system.log


# @OSX: vmware fusion; VMWare Fusion
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sudo vi /Library/Preferences/VMware\ Fusion/networking	change host network settings

# change the network configuration:
# edit the files in: /Library/Preferences/VMware Fusion
# after configuration run:
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure


# @OSX: shortcuts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
<shift> + <cmd> + 3:	# print screen to desktop
<shift> + <cmd> + 4:	# print selection to desktop


# @OSX: init
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/etc/init.d of OSX = /usr/libexec


# @OSX: network
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# change hostname:
sudo scutil --set HostName <hostname.domain>

# nfs mount
sudo mount -o -P <server>:/dir	/mnt

# netstat pendant:
sudo lsof -i -P | grep -i listen

# restart network adapter nic
sudo ifconfig enX down
sudo ifconfig enX up


# @OSX: disk
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diskutil list
diskutil coreStorage list


# @OSX: kernel, modules
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kextstat
sudo kextunload -b <moduleName>


# @OSX: ports collection, software repository
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sudo port -d sync				# update the port collection tree
sudo port search <keyword>		# search for available ports
sudo port install <portName>	# installs the choosen port


# @OSX: tor
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tor -f /opt/local/etc/tor/torrc	# starts tor with the specifiec config file. Adjust your browser proxy to the tor SOCKS proxy.


# @OSX: serial terminal console
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# connect serial to USB adapter
# check for newest devices
ls -lart /dev | tail
screen <device> <baudRate>
screen /dev/ttys007 9600
# end console with Ctrl+a Ctrl+d

# serial device infos:
sudo ioreg -c IOSerialBSDClient


# @OSX: terminal error
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ERROR: xterm-color: Unknown terminal type
RESOLUTION: 
# export TERM='vt100'


# @OSX: mobilebackup, time machine
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# disable mobile backup:
sudo tmutil disablelocal

