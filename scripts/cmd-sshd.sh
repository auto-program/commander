#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ sshd

function _cmd_sshd_setup_(){
	echo -n "please set sshd host ip address at cmd-network (default: $cmd_sshd_host): "
	read n;
	if [[ $n == "" ]]; then
		if [[ $cmd_sshd_host == "" ]]; then
			echo -n "ip address can't be empty."
			return	
		fi
		
		n=$cmd_sshd_host
	fi
	_sshd_address_=$n

	echo -n -s "please set root password: "
	read n;
	if [[ $n == "" ]]; then
		echo -n "root password can't be empty."
		return
	fi
	_root_password_=$n

	if [[ ! -d $_COMMANDER_HOME/configs/sshd ]]; then
		_exec_ mkdir $_COMMANDER_HOME/configs/sshd	
		echo "directory created: $_COMMANDER_HOME/configs/sshd"
	fi

	if [[ ! -d $_COMMANDER_HOME/volumns/sshd ]]; then
		_exec_ mkdir $_COMMANDER_HOME/volumns/sshd	
		echo "directory created: $_COMMANDER_HOME/volumns/sshd"
	fi

	_cf_var_write_ "sshd/setup.sh" "cmd_sshd_host" $_sshd_address_

	cat <<EOF >> $_COMMANDER_HOME/configs/sshd/Dockerfile
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:$_root_password_' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EOF

	docker stop cmd-sshd > /dev/null 2>&1
	docker rm cmd-sshd > /dev/null 2>&1		
	
	docker build -t sshd $_COMMANDER_HOME/configs/sshd
	docker run -d --network=cmd-network --ip $_sshd_address_ --name cmd-sshd -v $_COMMANDER_HOME/volumns/sshd:/home -p 127.0.0.1:1022:22 sshd
}


function cmd-sshd(){
	__doc__ 基于docker的sshd服务
	case "$1" in
	"" | -h )
		echo "Usage: cmd-sshd [ setup | start | stop | bash ]"
		echo
		;;
	"setup" )
		_cmd_sshd_setup_
	;;
	"start" )
		docker start cmd-sshd
	;;
	"stop" )
		docker stop cmd-sshd
	;;
	"bash" )
		docker exec -i -t cmd-sshd bash
	;;
	esac	
}
complete -W "setup start stop bash" cmd-sshd
