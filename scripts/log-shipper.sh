#!/bin/bash
# Mon May 23 14:37:55 CEST 2016
# christian.frei@umb.ch
#
# ships logs to a remote server

VERBOSE=0
LOG=/var/log/messages

# defaults
REMOTESERVER="localhost"
REMOTEUSER="umb"
REMOTECREDS="/home/umb/.ssh/id_rsa"

SHIPSRC="/var/log/archive"
SHIPDEST="/tmp"

RETENTIONARCHIVE=1		# retention time in days within the archive

ARCHNAME=$(hostname -s)_$(date "+%Y-%m-%d")



# functions
print_usage() {
	echo -e "Usage:\t$0 [ARGS]\n \
	\tARGS:\n
	\t\t-r,--retention\t[days] of logfiles within archive\n \
	\t\t-s,--src-dir\tfrom which local dir should logs be shipped\n \
	\t\t-d,--dest-dir\tto which dir on remote host should logs be shipped\n \
	\t\t-H,--host\tremote host\n \
	\t\t-u,--user\tremote user\n \
	\t\t-v,--verbose\n" 
}

pre_checks() {
	[[ ! -f ${LOG} ]] && echo "[WARN] ${LOG} does not exist."
	[[ ! -d ${SHIPSRC} ]] && logger -f ${LOG} -t $0 "[ERROR] ${SHIPSRC} does not exist. exiting." && exit 1
}

pack() {
	local cmdFind="find . -mtime +${RETENTIONARCHIVE} -type f -print0" 
	local cmdTar="tar -czf ${ARCHNAME}.tar.gz --null -T -"
	[[ -z ${VERBOSE} ]] && echo -e "[INFO] packing cmd: $cmdFind | $cmdTar"
	cd ${SHIPSRC}
	$cmdFind | $cmdTar 2>${LOG}
	if [ $? -gt 0 ]; then
		logger -f ${LOG} -t $0 "[ERROR] log packing failed. exiting."
		logger -f ${LOG} -t $0 "[ERROR] failed packing command: $cmdFind | $cmdTar"
		exit 1
	fi
}

ship() {
	if [ -z ${VERBOSE} ]; then
		cmd="scp -i ${REMOTECREDS} ${ARCHNAME}.tar.gz ${REMOTEUSER}@${REMOTESERVER}:${SHIPDEST}"
		echo -e "[INFO] shipping cmd: $cmd"
	else
		cmd="scp -q -i ${REMOTECREDS} ${ARCHNAME}.tar.gz ${REMOTEUSER}@${REMOTESERVER}:${SHIPDEST}"
	fi
	$cmd 2>${LOG}
	if [ $? -gt 0 ]; then
		logger -f ${LOG} -t $0 "[ERROR] log shipping failed. exiting."
		logger -f ${LOG} -t $0 "[ERROR] failed shipping command: $cmd"
		exit 1
	fi
}

# main
while [[ $# > 0 ]]; do
	key="$1"
	case $key in
		"-r"|"--retention" )
		RETENTIONARCHIVE=$2
		shift 2
		;;
		"-s"|"--src-dir" )
		SHIPSRC=$2
		shift 2
		;;
		"-d"|"--dest-dir" )
		SHIPDEST=$2
		shift 2
		;;
		"-H"|"--host" )
		REMOTESERVER=$2
		shift 2
		;;
		"-u"|"--user" )
		REMOTEUSER=$2
		shift 2
		;;
		"-v"|"--verbose" )
		unset VERBOSE
		shift
		;;
		"-h"|"--help" )
		print_usage
		exit 1
		;;
		*)
		break
		;;
	esac
done

pre_checks
pack
ship

[[ -z ${VERBOSE} ]] && echo -e "[INFO] shipping completed successfully. exiting."
logger -f ${LOG} -t $0 "[INFO] shipping completed successfully. exiting."

exit 0
