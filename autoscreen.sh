# autoscreen
# auto start screen session without inception

# source this after all other setup files
if [ -z "$STY" ]
then
 echo "Starting screen. ^C to cancel..."
 sleep 2
 screen -D -RR
 exit
fi

