#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ mysql

_check_ "docker"
ret=$?
if [[ "$ret" == "1" ]]; then 
	_error_ "cmd-mysql: please visit https://www.docker.com , install [ Docker Toolbox ] first."
fi

_check_ "mycli"
ret=$?
if [[ "$ret" == "1" ]]; then 
	echo "brew installing mycli ..."
	_exec_ brew install mycli
	echo "brew installing mycli ... ok."
fi

function _cmd_mysql_setup_(){
	echo -n "please set mysql host ip address at cmd-network (default: $cmd_mysql_host): "
	read n;
	if [[ $n == "" ]]; then
		if [[ $cmd_mysql_host == "" ]]; then
			echo -n "ip address can't be empty."
			return	
		fi
		
		n=$cmd_mysql_host
	fi
	_mysql_address_=$n

	_mysql_password_=$cmd_mysql_password
	if [[ $_mysql_password_ == "" ]]; then
		echo -n "please set root password: "
		read -s n;
		if [[ $n == "" ]]; then
			echo -n "root password can't be empty."
			return
		fi
		_mysql_password_=$n
	fi 

	

	if [[ ! -d $_COMMANDER_HOME/configs/mysql ]]; then
		_exec_ mkdir $_COMMANDER_HOME/configs/mysql
		echo "directory created: "$_COMMANDER_HOME/configs/mysql
	fi 

	_cf_var_write_ "mysql/setup.sh" "cmd_mysql_host" $_mysql_address_
	_cf_var_write_ "mysql/setup.sh" "cmd_mysql_password" $_mysql_password_

	docker stop cmd-mysql > /dev/null 2>&1
	docker rm cmd-mysql > /dev/null 2>&1

	docker run --network=cmd-network --ip $_mysql_address_ --name cmd-mysql -v $_COMMANDER_HOME/volumns/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$_mysql_password_ -p 127.0.0.1:3306:3306 -d mysql:5.7
}

function cmd-mysql(){
	__doc__  docker mysql service
	case "$1" in
	"" | -h )
		echo "Usage: cmd-mysql [setup | start | stop | bash | cli]"
		echo
		;;
	"setup" )
		_cmd_mysql_setup_
	;;
	"start" )
		docker start cmd-mysql
	;;
	"stop" )
		docker stop cmd-mysql
	;;
	"bash" )
		docker exec -i -t cmd-mysql bash
	;;
	"cli" )
		 mycli -h127.0.0.1 -uroot
	;;
	esac	
}
complete -W "setup start stop bash cli" cmd-mysql