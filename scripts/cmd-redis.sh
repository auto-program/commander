#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ redis

_check_ "redis-cli"
ret=$?
if [[ "$ret" == "1" ]]; then 
	echo "brew installing redis-cli ..."
	_exec_ brew install redis-cli
	echo "brew installing redis-cli ... ok."
fi

function _cmd_redis_setup_(){
	echo -n "please set redis host ip address at cmd-network (default: $cmd_redis_host): "
	read n;
	if [[ $n == "" ]]; then
		if [[ $cmd_redis_host == "" ]]; then
			echo -n "ip address can't be empty."
			return	
		fi
		
		n=$cmd_redis_host
	fi
	_redis_address_=$n

	if [[ ! -d $_COMMANDER_HOME/configs/redis ]]; then
		_exec_ mkdir $_COMMANDER_HOME/configs/redis
		echo "directory created: "$_COMMANDER_HOME/configs/redis
	fi 

	_cf_var_write_ "redis/setup.sh" "cmd_redis_host" $_redis_address_

	docker stop cmd-redis > /dev/null 2>&1
	docker rm cmd-redis > /dev/null 2>&1
	
	docker run --network=cmd-network --ip $_redis_address_ --name cmd-redis -v $_COMMANDER_HOME/volumns/redis:/data -p 127.0.0.1:6379:6379 -d redis
}

function cmd-redis(){
	__doc__ 基于docker的Redis服务
	case "$1" in
	"" | -h )
		echo "Usage: cmd-redis [setup | start | stop | bash | cli]"
		echo
		;;
	"setup" )
		_cmd_redis_setup_
	;;
	"start" )
		docker start cmd-redis
	;;
	"stop" )
		docker stop cmd-redis
	;;
	"bash" )
		docker exec -i -t cmd-redis bash
	;;
	"cli" )
		redis-cli
	;;
	esac	
}
complete -W "setup start stop bash cli" cmd-redis