# my .bashrc
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

docroot='~/Google\ Drive/08_technical/01_myKnowledge'
uxnotes="$docroot/allgemeinUnixLinux.sh"
bashnotes="$docroot/bash.txt"
pythonnotes="$docroot/python.txt"
ansiblenotes="$docroot/ansible.txt"
mysshkeys=( \
'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg9ILc/TTz3YVAj1NXC7baoygrrnj13WmkplX6y9bJqYt7yElUPsYI45nNUthUjFRVOi+CJFWrPLRGFjx6zkmHWKSCP1kMU1wZwg7Ah+86ohS1oY0YCUG+RBHi2rblt/LOrGtdi3nCtNbOIt7l8Y7Y7HOojVmP0zsIpGZej+/WVr/pOgk3t3UD6olSp9TTjymZkukFHFb4xgkR/e4OH0Cs8xA91htfEh/H8aTTKmRoAGBWXw6wn8k5SYYlVRoW23bN2rsl7YWidPzGZjUlv2ySFGHUk7t2t31PNn58FzGAYGYyfNpVbESp2NsDJfDTIV49qt+6TmVZOHF25a0y2KYJ christian.frei@fossbit.com' \
'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCul9VC/kHgsmQftHSaua24n57UHsFcIMWCNBUdKH204YKR7U2NZ2kJ+vZVAkHy04kp5stcaF14TAYiO9AGm7iI6ygPAjSvvMahVi55+AxsaTsoiedqYeT7JsHPwcFcC2Fv3K7I83+owTHhUK2oSYe7/5u/shvJ6jQpIOexBjZcLV+DXE6hlU811zhuKrGH/xSfj13v4mUE2+xFWDeg0KZic8UKL8fAXS5EC5E9tGK59QaG4kAa+6cFvpFU9HSXYJh3nq1iRK3UEf9Zpb/QJxmXa8Mv6hReMibHoQ4qN5AtL8OjZaS7SC9DAoRWTOnnygePQpcvpm1I5eFuYJYG5NIUn/PCSmVwkhCUkBu99Uy96GP/voSoQic1JQbqtC5lc1VPSn1iE+vIQrndukV70G8bP7Ceb2lDeaKMDEPtK6/vSXsLbL9OkyIaykbJPRjgYGMDyeDCvIKGPT+rkDfSJRW09zjKJykn1GqzXw8RBjVJsFtjGbjoJ4ccyU9wZDLFEJfoiPKGEQOZa4N7f4TRRfhg7+qTMwgViIDxSyP5ynFxw+6/QRvtgVeL1znSxyoZTdZe+IAMgnO57WMWPGN2VsXquhFHWodj4LsorR1y/vG3piUVpKR1lMyP3B3PfBw0cM8MF3Mddv9YfSkXC7GNm8iFHr4saUaH+R0RBn2QEF/j1w== christian.frei@adnovum.ch' )

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
  function nonzero_return() {
  	RETVAL=$?
  	[ $RETVAL -ne 0 ] && echo "$RETVAL"
  }

  export PS1="\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\w \[\e[36m\]\d\[\e[m\] \t \[\e[31m\]\`nonzero_return\`\[\e[m\]\n\\$ "
  # PS1="\[\033[38;5;3m\]\u\[$(tput sgr0)\]\[\033[38;5;0m\]@\[$(tput sgr0)\]\[\033[38;5;4m\]\h\[$(tput sgr0)\]\[\033[38;5;0m\]:\[$(tput sgr0)\]\[\033[38;5;8m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;94m\]\d\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;94m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;1m\]\$?\[$(tput sgr0)\]\[\033[38;5;15m\]\n\[$(tput sgr0)\]\[\033[38;5;0m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
else
  export PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# adjust prompt if git is available
if git --version 1> /dev/null; then
  # get current branch in git repo
  function parse_git_branch() {
  	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  	if [ ! "${BRANCH}" == "" ]
  	then
  		STAT=`parse_git_dirty`
  		echo "[${BRANCH}${STAT}]"
  	else
  		echo ""
  	fi
  }

  # get current status of git repo
  function parse_git_dirty {
  	status=`git status 2>&1 | tee`
  	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  	bits=''
  	if [ "${renamed}" == "0" ]; then
  		bits=">${bits}"
  	fi
  	if [ "${ahead}" == "0" ]; then
  		bits="*${bits}"
  	fi
  	if [ "${newfile}" == "0" ]; then
  		bits="+${bits}"
  	fi
  	if [ "${untracked}" == "0" ]; then
  		bits="?${bits}"
  	fi
  	if [ "${deleted}" == "0" ]; then
  		bits="x${bits}"
  	fi
  	if [ "${dirty}" == "0" ]; then
  		bits="!${bits}"
  	fi
  	if [ ! "${bits}" == "" ]; then
  		echo " ${bits}"
  	else
  		echo ""
  	fi
  }

  export PS1="\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\w \[\e[36m\]\d\[\e[m\] \t \[\e[31m\]\`nonzero_return\`\[\e[m\] \[\e[35m\]\`parse_git_branch\`\[\e[m\]\n\\$ "
fi

# what flavour do we use
if uname -a | grep Linux >/dev/null; then
  os="Linux"
  if [ -e /etc/redhat-release ]; then
    flavour="redhat"
  elif [ -e /etc/os-release ]; then
    flavour=$(cat /etc/os-release | egrep "^ID=" | cut -d'=' -f2)
  else
    flavour="unknown"
  fi
elif uname -a | grep Darwin >/dev/null; then
  os="OSX"
  flavour="osx"
fi

#export TERM=xterm-256color
# proxy settings
# PROXY="proxy.yourDomain.ch:3128"
# export http_proxy=http://$PROXY
# export HTTP_PROXY=http://$PROXY
# export https_proxy=https://$PROXY
# export HTTPS_PROXY=https://$PROXY

# glcoud
gcloud_path="/usr/local/google-cloud-sdk"
if [ -f $gcloud_path/completion.bash.inc ]; then
  source $gcloud_path/completion.bash.inc
fi
if [ -f $gcloud_path/path.bash.inc ]; then
  source $gcloud_path/path.bash.inc
fi

# make less more friendly for non-text input files, see lesspipe(1)
if [ "$flavour" != "coreos" ]; then
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
fi

# generic aliases
alias via="vim $uxnotes"
alias vib="vim $bashnotes"
alias vip="vim $pythonnotes"
alias vians="vim $ansiblenotes"

# Linux aliases
if [ "$os" == "Linux" ]; then
  alias ll='ls -alh --color=auto'
  alias op='netstat -tulpn'

  if [ "$flavour" == "ubuntu" ]; then
    alias tam='tail -f /var/log/syslog'
    alias lam='less /var/log/syslog'
  else
    alias tam='tail -f /var/log/messages'
    alias lam='less /var/log/messages'
  fi

  # If set, the pattern "**" used in a pathname expansion context will
  # match all files and zero or more directories and subdirectories.
  shopt -s globstar

# OSX aliases
elif [ "$os" == "OSX" ]; then
  alias ll='ls -alhG'
  alias op='sudo lsof -i -P | grep -i listen'
  alias tam='tail -f /var/log/system.log'
  alias lam='less /var/log/system.log'
  alias tad='tail -f ~/Library/Containers/com.docker.docker/Data/log/system.log'
  alias docker-console='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
fi

# coreos aliases
if [ "$flavour" == "coreos" ]; then
  alias htop="docker run --rm -it --pid host frapsoft/htop"
fi

# source local aliases
if [ -f ~/.myalias ]; then
  source ~/.myalias
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

os-info() {
  echo -en "\n         OS: "
  if [ "$flavour" == "redhat" ]; then
    cat /etc/redhat-release
  elif [ "$flavour" == "ubuntu" ]; then
    cat /etc/lsb-release | grep DESCRIPTION | cut -d'"' -f2
  else
    cat /etc/issue
  fi

  if [ -e /proc/cpuinfo ]; then
    echo -en "     Kernel: "
    uname -r
    echo -en "        Mem: "
    free -h | grep Mem | awk '{print $2}'
    echo -en "        CPU:"
    cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d':' -f2
    echo -en " Proc Units: "
    cat /proc/cpuinfo | grep processor | wc -l
    echo
  fi
}

ssh-key-distribution() {
  if [ ! $# -eq 0 ]; then
    HOSTS=$@
  fi

  if [ "$HOSTS" == "" ]; then
    echo -en "\n      please provide hostlist (one list for one password): "
    read HOSTS
    export HOSTS
  else
    echo -e "\n   configure SSH for $HOSTS"
  fi

  pw=""
  if which sshpass >/dev/null; then
    echo -en "      please enter password: "
    read -s pw
    echo
    echo -e "      ... working ..."
  fi

  if [ ! -e $HOME/.ssh/id_rsa ]; then
    ssh-keygen -trsa -b4096 -f $HOME/.ssh/id_rsa -N '' >/dev/null
  fi

  if [ "$HOSTS" != "" ]; then
    for h in $HOSTS; do
      if [ "$pw" == "" ]; then
        ssh-copy-id -i $HOME/.ssh/id_rsa.pub $h >/dev/null
      else
        sshpass -p $pw ssh-copy-id -i $HOME/.ssh/id_rsa.pub $h >/dev/null
      fi

      ssh $h "touch $HOME/.ssh/authorized_keys; chmod 600 $HOME/.ssh/authorized_keys"
      for k in "${mysshkeys[@]}"; do
        echo "${k}" | ssh ${h} "cat >> $HOME/.ssh/authorized_keys"
      done

    done
  fi

  echo
  unset pw

  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
}

run-on-many() {
  cmd=$@

  if [ "$HOSTS" == "" ]; then
    echo -en "\n   please provide [user@]host list: "
    read HOSTS
    export HOSTS
  else
    echo -e "running command on $HOSTS (to change: \"unset HOSTS\")"
  fi

  for h in $HOSTS; do
    echo -e "\n$h\n-----------------------"
    ssh $h $cmd
  done
}

setup-packages() {
  pkgs="wget curl git bash-completion net-tools vim-enhanced bind-utils jq"
  if [ "$flavour" == "redhat" ]; then
    yum install -y $pkgs
  elif [ "$flavour" == "ubuntu" ]; then
    apt-get install $pkgs
  else
    echo -e "OS $os ($flavour) unknown."
  fi
}

# handy docker stuff
if docker >/dev/null 2>&1; then

  alias dps='docker ps'
  alias dpa='docker ps -a'
  alias dim='docker images'
  alias dip='docker inspect'
  alias drd="docker run -d -P"
  alias dri="docker run -ti -P"
  alias dkl="docker kill"
  alias dst="docker stop"
  alias drm="docker rm"
  alias drmi="docker rmi"
  alias dex="docker exec -ti"
  alias dlo="docker logs"
  alias dvl="docker volume list"
  alias dvi="docker volume inspect"
  alias dnl="docker network list"
  alias dni="docker network inspect"
  alias dcu="docker-compose up -d"
  alias dcd="docker-compose down"

  did() { export id=$(docker ps -l -q); echo $id; }
  docker-rm-all() { docker rm $(docker ps -q -a); }
  docker-img-rm() { docker rmi $(docker images -q); }
  docker-vol-rm() { docker volume ls -qf dangling=true | xargs docker volume rm; }
  dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

  docker-vol-rm-all() {
    for i in $(docker volume ls | grep local | awk '{print $2}'); do
      docker volume rm $i;
    done
  }

  docker-push-all-images() {
    if [ -z ${REG} ]; then
      echo -en "\n   please provide desired target registry: "
      read REG
      export REG
    else
      echo -en "\n   Going to push to: $REG (change: unset REG)"
    fi

    docker images | grep -v REPO | while IFS= read -r l; do
      image=$(echo $l | awk '{print $1}')
      tag=$(echo $l | awk '{print $2}')
      if [ "$REG" == $(echo $image | cut -d'/' -f1) ]; then
        image=$(echo $image | cut -d'/' -f2)
      fi

      echo -e "\n   process $image:$tag ..."
      docker tag $image:$tag $REG/$image:$tag
      docker push $REG/$image:$tag

      unset image
      unset tag
    done
  }
fi
