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
    awk 'NR>1' $CSVPATH | while IFS=',' read -r host port proctype procname load                    # read processes and parameters
    do
      port=$(eval "echo $port")
      load=$(eval "echo $load")
      #echo "$host $port $proctype $procname $load"                                                  # print processes to console
      args="-stackid ${RITOBASEPORT} -proctype $proctype -procname $procname"
      pid="pgrep -f \"\\$args\""

      rlr="rlwrap -r "
      sline="${QHOME}/m64/q ${load} $args -p ${port}" 
      #ßecho $sline
      rtrn="$rtrn\n$host $port $proctype $procname $load $(eval $pid)"

    done
    echo $rtrn
}

start() {
    awk 'NR>1' $CSVPATH | while IFS=',' read -r host port proctype procname load                    # read processes and parameters
    do
      port=$(eval "echo $port")                                                                     # show port number
      load=$(eval "echo $load")                                                                     # show full path
      echo "$host $port $proctype $procname $load"
      args="-stackid ${RITOBASEPORT} -proctype $proctype -procname $procname"
      sline="rlwrap -r ${QHOME}/m64/q ${load} $args -p ${port}"                                     # build run cmd for each process
      eval "${sline} > '${RITOLOG}/${procname}.log' 2>&1 &"                                         # run cmd for each process
    done
}

stop() {
  awk 'NR>1' $CSVPATH | while IFS=',' read -r host port proctype procname load                    # read processes and parameters
  do
    port=$(eval "echo $port")
    load=$(eval "echo $load")
    #echo "$host $port $proctype $procname $load"                                                  # print processes to console
    args="-stackid ${RITOBASEPORT} -proctype $proctype -procname $procname"
    pid="pkill -f \"\\$args\""
    eval $pid
  done
}

 

case $1 in
  start)
    start "$*";
    ;;
  showprocs)
    readproc "$*";
    ;;
  "")
    usage
    ;;
  stop)
    stop "$*";
    ;;
  *)
    echo "ERROR: Invalid argument(s)"
    exit 1
    ;;
esac