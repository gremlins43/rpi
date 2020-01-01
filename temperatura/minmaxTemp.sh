#!/bin/bash

# work on script directory
cd "$(dirname "$0")"

#get temperature from rpi
TEMP=$(vcgencmd measure_temp)

#clean the output to be saved
TEMP=$(echo $TEMP | grep -oP [0-9]{2})
TODAY=$(echo "`date +%D`")

if [ -f temp_log.csv ]
then
        echo "`date +%D` `date +%T`;" $TEMP >> temp_log.csv

        if [ -f dayMinMax.csv ]
        then
                if [ -f currentDay ]
                then
                        currentDay=$(cat currentDay)
                                if [ "$currentDay" == "$TODAY" ]
                                then
                                        if [ -f today.csv ]
                                        then
                                                echo "`date +%D` `date +%T`;" $TEMP >> today.csv
                                        else
                                                echo "`date +%D` `date +%T`;" $TEMP > today.csv
                                        fi
                                else
                                        Maxi=$(cat today.csv | cut -c20-21 | sort | tail -n 1)
                                        Mini=$(cat today.csv | cut -c20-21 | sort | head -n 1)
                                        cat today.csv | egrep "( $Maxi)|( $Mini)" >> dayMinMax.csv
                                        echo " $Maxi" "_and_" " $Mini"
                                        echo "`date +%D` `date +%T`;" $TEMP > today.csv
                                        echo $TODAY > currentDay
                                fi
                else
                        echo $TODAY > currentDay
                fi
        else
                touch dayMinMax.csv
        fi
else
                echo "`date +%D` `date +%T`;" $TEMP >> temp_log.csv
fi
