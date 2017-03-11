#!/bin/bash

# you can set the build time here
build_time='01:00'

# kill konka_loop_autobuild.sh process before
ps aux | grep $0 | grep -v $$ | grep -v 'grep' | awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
while true
do
    time_now=$(date +%s)
    build_time_s=$(date +%s -d $build_time)
    if [[  $build_time_s > $time_now ]]
    then
        sleep_time=$(( $build_time_s - $time_now ))  
        echo huaqing.fang
        echo $sleep_time
    else
        sleep_time=$(( $build_time_s + 3600*24 - $time_now ))  
        echo $sleep_time
    fi
    sleep $sleep_time
     
    # do something
    ./KDL40MH660UN.sh
    ./KDL40MH660LN.sh

done
