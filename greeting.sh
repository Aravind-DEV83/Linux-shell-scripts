#Program to pring Good Morining, Good Afternoon, Good Evening
# & Good Night, according to the system time.


#!/bin/bash
hour=`date +%H`

if [ $hour -lt 12 ]
then echo "Good Morning!!"
elif [ $hour -lt 16 ]
then echo "Good Afternoon!!"
elif [ $hour -lt 20 ]
then echo "Good Evening"
else echo "Good Night"
fi
