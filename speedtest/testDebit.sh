#!/bin/bash

# work on script directory
cd "$(dirname "$0")"

# scriptPath=$(</home/pi/script/speedtest)
# cd $scriptPath
echo "========" >> debit.log 
date >> debit.log 
/usr/local/bin/speedtest-cli --simple &>> debit.log
