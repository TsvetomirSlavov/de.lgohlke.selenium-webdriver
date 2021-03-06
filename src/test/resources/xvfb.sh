#!/bin/bash

#set -e
#set -x

display=$1
cmd=$2

function wait_until_xvfb_up {
    export DISPLAY=":$1.0"

    max=20
    i=0
    while true; do
        i=$((i+1));
        echo "test display $DISPLAY (attempt $i / $max )"
        timeout 5s xterm -e "bash -c 'exit'"
        lastExitCode=$?

        if [ $lastExitCode -eq 0 ];
            then break;
            else sleep 0.5;
        fi

        if [ $i -eq $max ]; then break; fi;
    done

    exit $lastExitCode
}

case $cmd in
 start)
    echo "starting xvfb on DISPLAY :$display"
    Xvfb -ac -nolisten tcp :$display &
    echo -n $! > xvfb.$display.pid
    wait_until_xvfb_up $display
    echo "started xvfb with display $display"
 ;;
 stop)
    echo -n "kill xfvb on display $display ... "
    kill $(cat xvfb.$display.pid) && echo ok && rm xvfb.$display.pid || echo failed
 ;;
 restart)
    $0 $display start
    $0 $display stop
 ;;
esac
