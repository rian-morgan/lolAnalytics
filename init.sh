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

readproc() {
    awk 'NR>1' $CSVPATH | while IFS=',' read -r host port proctype procname load
    do
      echo "$host $port $proctype $procname $load"
    done 
}

start() {
    awk 'NR>1' $CSVPATH | while IFS=',' read -r host port proctype procname load
    do
      echo "$host $port $proctype $procname $load"
      sline="rlwrap -r ${QHOME}/m64/q ${load} -p ${port}"
      eval "${sline} > '${RITOLOG}/${procname}.log' 2>&1 &"
    done
}

case $1 in
  start)
    start "$*";
    ;;
  readprocs)
    readproc "$*";
    ;;
  "")
    usage
    ;;
  *)
    echo "ERROR: Invalid argument(s)"
    exit 1
    ;;
esac