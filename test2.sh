#!/bin/bash

#get temperature from rpi
TEMP=$(vcgencmd measure_temp)

#clean the output to be saved
#TEMP=$(echo $TEMP | grep -oP [0-9]{2}.[0-9])
TEMP=$(echo $TEMP | grep -oP [0-9]{2})
#TODAY=$(echo "`date +%D`") | tr / -)
TODAY=$(echo "`date +%D`") 
if [ -f "/home/pi/script/currentDay" ]
then
	if [ -f "/home/pi/script/max" ]
	then
		Maxi=$(</home/pi/script/max)
		if [ $TEMP -ge $Maxi ]
		then
			echo $TEMP > "/home/pi/script/max"
		else
			if [ -f "/home/pi/script/min" ]
			then
				Mini=$(</home/pi/script/min)
				if [ $TEMP -le $Mini ]
				then
					echo $TEMP > "/home/pi/script/min"
				fi
			else
				#min file does not exists, creating it:
				echo $TEMP > "/home/pi/script/min"
			fi

		fi
	else
					#max file does not exists, creating it:
					echo $TEMP > "/home/pi/script/max"

	fi
# store min/max values if day changed:
#        currentDay=$(cat /home/pi/script/currentDay)# | tr / -)
        currentDay=$(cat /home/pi/script/currentDay)
       echo "current day_" $currentDay "_"
        echo "Today_" $TODAY "_"
        if [ "$currentDay"=="$TODAY" ]
        then
		echo "equal"
	else
                echo $currentDay >> "/home/pi/script/dayMinMax.log"
                echo $Maxi >> "/home/pi/script/dayMinMax.log"
                echo $Mini >> "/home/pi/script/dayMinMax.log"
		echo "diff"
        fi

else
        echo $TODAY > "/home/pi/script/currentDay"
fi
