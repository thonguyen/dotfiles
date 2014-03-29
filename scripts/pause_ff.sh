#!/bin/sh
#fpid=$(ps -ef|grep firefox| grep -v grep |awk '{print $2}')
fpid=`pidof firefox`
state=$(cat /proc/${fpid}/stat | awk '{print $3}')
if [[ "${state}" == "T" ]]
then
    kill -CONT ${fpid}
else
    kill -STOP ${fpid}
fi
