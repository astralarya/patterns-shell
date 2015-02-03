# SSH proxy function
ssh-proxy () {
local conn=$1
local port=$2
if [ -z "$port" ]
then
 local port=9999
fi
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: ssh-proxy USER@HOST:PORT [LOCALPORT] [OPTION]
Start an SSH proxy via USER@HOST:PORT on localhost:LOCALPORT (default 9999).
Option		GNU long option		Meaning
-h		--help			Show this message"
else
 echo "Starting SOCKS host to kimmm@rokasgate.accre.edu on localhost:$port (^C to STOP)"
 ssh -D $port -C "conn" "echo 'Success!'; cat > /dev/null"
 true
fi
}
