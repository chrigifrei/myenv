# my .bashrc
docroot='~/Google\ Drive/08_technical/01_myKnowledge'
uxnotes="$docroot/allgemeinUnixLinux.sh"
bashnotes="$docroot/bash.txt"
pythonnotes="$docroot/python.txt"
ansiblenotes="$docroot/ansible.txt"
mysshkeys=( \
'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg9ILc/TTz3YVAj1NXC7baoygrrnj13WmkplX6y9bJqYt7yElUPsYI45nNUthUjFRVOi+CJFWrPLRGFjx6zkmHWKSCP1kMU1wZwg7Ah+86ohS1oY0YCUG+RBHi2rblt/LOrGtdi3nCtNbOIt7l8Y7Y7HOojVmP0zsIpGZej+/WVr/pOgk3t3UD6olSp9TTjymZkukFHFb4xgkR/e4OH0Cs8xA91htfEh/H8aTTKmRoAGBWXw6wn8k5SYYlVRoW23bN2rsl7YWidPzGZjUlv2ySFGHUk7t2t31PNn58FzGAYGYyfNpVbESp2NsDJfDTIV49qt+6TmVZOHF25a0y2KYJ christian.frei@umb.ch' \
'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCul9VC/kHgsmQftHSaua24n57UHsFcIMWCNBUdKH204YKR7U2NZ2kJ+vZVAkHy04kp5stcaF14TAYiO9AGm7iI6ygPAjSvvMahVi55+AxsaTsoiedqYeT7JsHPwcFcC2Fv3K7I83+owTHhUK2oSYe7/5u/shvJ6jQpIOexBjZcLV+DXE6hlU811zhuKrGH/xSfj13v4mUE2+xFWDeg0KZic8UKL8fAXS5EC5E9tGK59QaG4kAa+6cFvpFU9HSXYJh3nq1iRK3UEf9Zpb/QJxmXa8Mv6hReMibHoQ4qN5AtL8OjZaS7SC9DAoRWTOnnygePQpcvpm1I5eFuYJYG5NIUn/PCSmVwkhCUkBu99Uy96GP/voSoQic1JQbqtC5lc1VPSn1iE+vIQrndukV70G8bP7Ceb2lDeaKMDEPtK6/vSXsLbL9OkyIaykbJPRjgYGMDyeDCvIKGPT+rkDfSJRW09zjKJykn1GqzXw8RBjVJsFtjGbjoJ4ccyU9wZDLFEJfoiPKGEQOZa4N7f4TRRfhg7+qTMwgViIDxSyP5ynFxw+6/QRvtgVeL1znSxyoZTdZe+IAMgnO57WMWPGN2VsXquhFHWodj4LsorR1y/vG3piUVpKR1lMyP3B3PfBw0cM8MF3Mddv9YfSkXC7GNm8iFHr4saUaH+R0RBn2QEF/j1w== extcfr@adnmac108.zh.adnovum.ch' )

if uname -a | grep Linux >/dev/null; then
  os="Linux" 
elif uname -a | grep Darwin >/dev/null; then 
  os="OSX"
fi

export TERM=xterm-256color
export PS1="\[\033[38;5;3m\]\u\[$(tput sgr0)\]\[\033[38;5;0m\]@\[$(tput sgr0)\]\[\033[38;5;4m\]\h\[$(tput sgr0)\]\[\033[38;5;0m\]:\[$(tput sgr0)\]\[\033[38;5;8m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;94m\]\d\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;94m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;1m\]\$?\[$(tput sgr0)\]\[\033[38;5;15m\]\n\[$(tput sgr0)\]\[\033[38;5;0m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# proxy settings
# PROXY="proxy.yourDomain.ch:3128"
# export http_proxy=http://$PROXY
# export HTTP_PROXY=http://$PROXY
# export https_proxy=https://$PROXY
# export HTTPS_PROXY=https://$PROXY

# generic aliases
alias ll='ls -alhG'
alias via="vim $uxnotes"
alias vib="vim $bashnotes"
alias vip="vim $pythonnotes"
alias vians="vim $ansiblenotes"

alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gh="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"


# Linux aliases
if [ "$os" == "Linux" ]; then
  alias op='netstat -tulpn'
  alias tam='tail -f /var/log/messages'
  alias lam='less /var/log/messages'

# OSX aliases
elif [ "$os" == "OSX" ]; then
  alias op='sudo lsof -i -P | grep -i listen'
  alias sublime='/Applications/Sublime\ Text\ 2.app/Contents/MacOS/Sublime\ Text\ 2'
  alias tam='tail -f /var/log/system.log'
  alias lam='less /var/log/system.log'
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

os-info() {
  echo -en "\n         OS: "
  if [ -e /etc/redhat-release ]; then
    cat /etc/redhat-release
  elif [ -e /etc/lsb-release ]; then
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

# my personal notes for all unix flavours
# myman() {
#   # to be done
# }

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
    echo -en "\n   please provide hostlist: "
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
  pkgs="wget curl git bash-completion net-tools vim-enhanced bind-utils"
  yum install -y $pkgs
}

# handy docker stuff
if docker >/dev/null 2>&1; then 

  alias docker-stop-all='docker stop $(docker ps -a -q)'
  alias docker-rm-all='docker rm $(docker ps -a -q)'

  docker-push-all-images() {
    if [ -z ${REG} ]; then
      echo -en "\n   please provide desired target registry: "
      read REG
      export REG
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
