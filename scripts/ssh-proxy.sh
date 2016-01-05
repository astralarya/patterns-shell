# SSH proxy function
ssh-proxy () {
    # read arguments
    local option
    local state
	local conn
	local port
    for arg in "$@"
    do
        if [ "$state" = "input" ]
        then
			if [ -z "$conn" ]
			then
				conn="$arg"
			elif [ -z "$port" ]
			then
				port="$arg"
			else
                \printf 'Ignored argument: %q\n' "$arg"
			fi
        elif [ "$state" = "option" ]
        then
			option+=("$arg")
			state=""
        elif [ "$arg" = "-h" -o "$arg" = "--help" ]
        then
			state="help"
			break
        elif [ "$arg" = "--" ]
        then
            state="input"
        elif [ -z "${arg/-*/}" ]
        then
			option+=("$arg")
			if [[ *"${arg:-1}"* == "bcDEeFIiLlmOopQRSWw" ]]
			then
				state="option"
			fi
        else
			if [ -z "$conn" ]
			then
				conn="$arg"
			elif [ -z "$port" ]
			then
				port="$arg"
			else
                \printf 'Ignored argument: %q\n' "$arg"
			fi
        fi
    done

	if [ "$state" = "help" -o -z "$conn" ]
	then
		\printf 'Usage: ssh-proxy [CONNECTION] [LOCALPORT] [OPTION]
Start an SSH proxy via CONNECTION (eg. USER@HOST:PORT) on localhost:LOCALPORT (default 9999).
Option		Meaning
-*			SSH option (see `man ssh`)
-h			Show this message
'
		return 0
	fi

	if [ -z "$port" ]
	then
		local port=9999
	fi

	\printf 'Starting SOCKS host to %q on localhost:%q (^C to STOP)\n' "$conn" "$port"
	ssh "${option[@]}" -D $port -C "$conn" "\\printf 'Success!\n'; cat > /dev/null"
}
