#!/bin/bash

#get temperature from rpi
TEMP=$(vcgencmd measure_temp)

#clean the output to be saved
TEMP=$(echo $TEMP | grep -oP [0-9]{2})
TODAY=$(echo "`date +%D`")

if [ -f "/home/pi/script/temperatura/temp_log.csv" ]
then
	echo "`date +%D` `date +%T`;" $TEMP >> "/home/pi/script/temperatura/temp_log.csv"

	if [ -f "/home/pi/script/temperatura/dayMinMax.csv" ]
	then
		if [ -f "/home/pi/script/temperatura/currentDay" ]
		then
			currentDay=$(cat /home/pi/script/temperatura/currentDay)
				if [ "$currentDay" == "$TODAY" ]
				then
					if [ -f "/home/pi/script/temperatura/today.csv" ]
					then
						echo "`date +%D` `date +%T`;" $TEMP >> "/home/pi/script/temperatura/today.csv"
					else
						echo "`date +%D` `date +%T`;" $TEMP > "/home/pi/script/temperatura/today.csv"
					fi
				else
					Maxi=$(cat today.csv | cut -c20-21 | sort | tail -n 1)
					Mini=$(cat today.csv | cut -c20-21 | sort | head -n 1)
					cat /home/pi/script/temperatura/today.csv | egrep "($Maxi)|($Mini)" >> "/home/pi/script/temperatura/dayMinMax.csv"
					echo " $Maxi" "_and_" " $Mini"
					echo "`date +%D` `date +%T`;" $TEMP > "/home/pi/script/temperatura/today.csv"
					echo $TODAY > "/home/pi/script/temperatura/currentDay"
				fi
		else
			echo $TODAY > "/home/pi/script/temperatura/currentDay"
		fi
	else
		touch /home/pi/script/temperatura/dayMinMax.csv
	fi
else
		echo "`date +%D` `date +%T`;" $TEMP >> "/home/pi/script/temperatura/temp_log.csv"
fi
