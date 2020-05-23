#!/bin/zsh

if [ "-bash" = $0 ]; then
  dirpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  dirpath="$(cd "$(dirname "$0")" && pwd)"
fi

if [ -z $SETENV ]; then
  SETENV=${dirpath}/setenv.sh                                                                       # set the environment if not predefined
fi

if [ -z $RLWRAP ]; then
  RLWRAP="rlwrap"                                                                                   # set environment if not predefined
fi

if [ -f $SETENV ]; then                                                                             # check script exists
  . $SETENV                                                                                         # load the environment
else
  echo "ERROR: Failed to load environment - $SETENV: No such file or directory"                     # show input file error
  exit 1
fi


#So far only 1 process so all files loaded into that in order. In future likely will be a gateway, rdb, hdb process, so will need to setup common and proc specific loading
#get q file load order from csv
#get csv data in array
#loadOrder=($(cut -d ',' -f1 ${RITOCONFIG}/loadOrder.csv))


sline="rlwrap -r $QHOME/m64/q $RITOQ/loader.q -p ${RITOBASEPORT}"

start() {
  { read
    while IFS=, read -r host port proctype procname load
    do
      echo "$host $port $proctype $procname $load"
      sline="rlwrap -r $QHOME/m64/q $load -p $port"
      eval "$sline > ${procname}.log 2>&1 &"
    done } < $CSVPATH

    #TODO - add procname, procid and port selection - expand to spin up multiple processes
    # run starter q script - this will load common files to all procs and proc specific scripts
#    eval "nohup $sline </dev/null > out.txt 2>&1 &"
    #eval "$sline"
}

case $1 in
  start)
    start "$*";
    ;;
  "")
    usage
    ;;
  *)
    echo "ERROR: Invalid argument(s)"
    exit 1
    ;;
esac