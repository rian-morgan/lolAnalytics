#!/bin/zsh
if [ "-bash" = $0 ]; then
  dirpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  dirpath="$(cd "$(dirname "$0")" && pwd)"
fi

## Environment variables ##
export QHOME=$HOME/q
export RITOHOME=`pwd`
export RITOQ=${RITOHOME}/qcode
export RITODATA=${RITOHOME}/data
export RITOBIN=${RITOHOME}/bin
export RITOCONFIG=${RITOHOME}/config
export CSVPATH=${RITOCONFIG}/processes.csv
export KDBLIB='~/q'
export KDBPATH=${KDBLIB}/m64
export KDBSRC=${RITOHOME}/src

export RLWRAP="rlwrap"

export RITOBASEPORT=5000

alias q='~/q rlwrap -r ~/q/m64/q'  