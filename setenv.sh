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
export RITOLOG=${RITOHOME}/logs
export KDBLIB='~/q'
export KDBPATH=${KDBLIB}/m64
export KDBSRC=${RITOHOME}/src
export RLWRAP="rlwrap"
export RITOBASEPORT=50000
export RITOAPIKEY="RGAPI-e1f4bf5d-85ad-4aa6-b35c-090dd4919e1a"
export SSL_CERT_FILE=$HOME/Documents/certs/server-crt.pem
export SSL_KEY_FILE=$HOME/Documents/certs/server-key.pem
export SSL_CA_CERT_FILE=$HOME/Documents/certs/ca.pem
export SSL_CA_CERT_PATH=$HOME/Documents/certs
export SSL_VERIFY_SERVER=NO

alias q='~/q rlwrap -r ~/q/m64/q'  