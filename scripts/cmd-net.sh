#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ net

_check_ "docker"
ret=$?
if [[ "$ret" == "1" ]]; then 
	_error_ "please visit https://www.docker.com , install [ Docker Toolbox ] first."
fi

_check_ "jq"
ret=$?
if [[ "$ret" == "1" ]]; then 
	echo "brew installing jq ..."
	_exec_ brew install jq
	echo "brew installing jq ... ok."
fi

function cmd-net(){
	__doc__ 基于docker的网络环境
	case "$1" in
	"" | -h )
		echo "Usage: cmd-net [create | remove | ls]"
		echo
		if [[ -f $_COMMANDER_HOME/configs/net/setup.sh ]]; then
			echo "cmd-network subnet: $cmd_net_subnet"
			echo "cmd-network gateway: $cmd_net_gateway"
			echo "cmd-network iprange: $cmd_net_iprange"
		fi
		;;
	"create" )
		echo -n "please input network subnet [default: $cmd_net_subnet]: " 
		read subnet
		if [[ $subnet == "" ]]; then
			if [[ $cmd_net_subnet == "" ]]; then
				echo "warn: network subnet can't be empty."
				return
			fi
			subnet=$cmd_net_subnet
		fi

		echo -n  "please input network gateway [default: $cmd_net_gateway]: "
		read gateway
		if [[ $gateway == "" ]]; then
			if [[ $cmd_net_gateway == "" ]]; then
				echo "warn: network gateway can't be empty."
				return
			fi
			gateway=$cmd_net_gateway
		fi

		echo -n  "please input network ip-range [default: $cmd_net_iprange]: " 
		read iprange
		if [[ $iprange == "" ]]; then
			if [[ $cmd_net_iprange == "" ]]; then
				echo "warn: network ip range can't be empty."
				return
			fi
			iprange=$cmd_net_iprange
		fi

		if [[ ! -d $_COMMANDER_HOME/configs/net ]]; then
			_exec_ mkdir $_COMMANDER_HOME/configs/net
			echo "directory created: "$_COMMANDER_HOME/configs/net
		fi 

		_cf_var_write_ "net/setup.sh" "cmd_net_subnet" $subnet
		_cf_var_write_ "net/setup.sh" "cmd_net_gateway" $gateway
		_cf_var_write_ "net/setup.sh" "cmd_net_iprange" $iprange	

		docker network rm cmd-network > /dev/null 2>&1
		docker network create --subnet=$subnet --gateway=$gateway --ip-range=$iprange cmd-network
	;;
	"remove" )
		docker network rm cmd-network
	;;
	"ls" )
		docker network inspect cmd-network | jq ".[0].Containers | to_entries | del(.[].value.EndpointID) | del(.[].value.MacAddress) | del(.[].value.IPv6Address) | .[].value"
	;;
	esac	
}
complete -W "create remove ls" cmd-network