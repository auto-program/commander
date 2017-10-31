#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ vpn

function cmd-vpn(){
	__doc__ 启停VPN服务命令
	case "$1" in
	"" | -h )
		echo "Usage: cmd-vpn [start | stop] [vpn-name]"
		echo
		;;
	"start" )
		if [[ $# -ne 2 ]]; then
			echo "Usage: cmd-vpn start [vpn-name]"
			echo "vpn-name absent."
			echo
			return
		fi
		networksetup -connectpppoeservice $2
		export vpn=$2
	;;
	"stop" )
		networksetup -disconnectpppoeservice $vpn
	;;
	esac	
}
complete -W "start stop" cmd-vpn
