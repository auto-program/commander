#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ ssh

function _ssh_agent_(){
	ssh-agent > /dev/null 2>&1
}

function _ssh_key_pub_(){
	for k in $@ ; do 
		if [[ -f $_COMMANDER_HOME/configs/ssh/.ssh/$k.pub ]]; then 
			_exec_ cat $_COMMANDER_HOME/configs/ssh/.ssh/$k.pub
		fi
	done
}

function _ssh_key_del_(){
	for k in $@ ; do 
		if [[ -f $_COMMANDER_HOME/configs/ssh/.ssh/$k ]]; then 
			_exec_ rm $_COMMANDER_HOME/configs/ssh/.ssh/$k
			_exec_ rm $_COMMANDER_HOME/configs/ssh/.ssh/$k.pub
		fi
	done
}

function _ssh_key_load_(){
	ssh-add -D > /dev/null 2>&1
	if [[ $# -gt 0 ]]; then
		for f in $@ ; do
			if [[ -f $_COMMANDER_HOME/configs/ssh/.ssh/$f ]]; then
				eval ssh-add $_COMMANDER_HOME/configs/ssh/.ssh/$f > /dev/null 2>&1
			fi
		done
	else 
		if [[ -d $_COMMANDER_HOME/configs/ssh/.ssh ]]; then
			for file in $(find "$_COMMANDER_HOME/configs/ssh/.ssh" -name "*.pub"); do
				eval ssh-add ${file%%.pub} > /dev/null 2>&1
			done	
		fi
	fi 
}

function _ssh_key_gen_(){
	if [[ $# -eq 0 ]]; then
		echo -n "ssh key identity: "
		read k;
		if [[ $k == "" ]]; then
			echo "ssh key identity can't be empty."
			return
		fi
	else 
		k=$1
	fi
	

	echo -n "ssh key description: "
	read n;
	if [[ $n == "" ]]; then
		n=$k
	fi 

	if [[ ! -d $_COMMANDER_HOME/configs/ssh ]]; then
		_exec_ mkdir -p $_COMMANDER_HOME/configs/ssh
		echo "created directory: $_COMMANDER_HOME/configs/ssh"
	fi

	if [[ ! -d $_COMMANDER_HOME/configs/ssh/.ssh ]]; then
		_exec_ mkdir -p $_COMMANDER_HOME/configs/ssh/.ssh
		echo "created directory: $_COMMANDER_HOME/configs/ssh/.ssh"
	fi

	ssh-keygen -f $_COMMANDER_HOME/configs/ssh/.ssh/$k  -C $n
}

function _ssh_srv_new_(){
	echo -n "ssh new connection name: "
	read n;
	if [[ $n == "" ]]; then
		echo -n "connection name can't be empty."
		return
	fi
	_srv_connection=$n
	
	echo -n "ssh connect host address: "
	read n;
	if [[ $n == "" ]]; then
		echo -n "host address can't be empty."
		return
	fi
	_srv_host=$n
	
	echo -n "ssh connect host port (default: 22): "
	read n;
	if [[ $n == "" ]]; then
		n=22
	fi
	_srv_port=$n

	echo -n "ssh connect user name (default: $USER): "
	read n;
	if [[ $n == "" ]]; then
		n=$USER
	fi
	_srv_user=$n

	_cf_var_write_ "ssh/$_srv_connection.sh" ${_srv_connection}"_host" $_srv_host
	_cf_var_write_ "ssh/$_srv_connection.sh" ${_srv_connection}"_port" $_srv_port
	_cf_var_write_ "ssh/$_srv_connection.sh" ${_srv_connection}"_user" $_srv_user

	echo -n "ssh connect ssh key identity (default: $_srv_connection): "
	read n;
	if [[ $n == "" ]]; then
		n=$_srv_connection
	fi
	_srv_key=$n
	_cf_var_write_ "ssh/$_srv_connection.sh" ${_srv_connection}"_key" $_srv_key

	echo
	echo "============================================================"
	echo " NOTE "
	echo "============================================================"

	if [[ ! -f $_COMMANDER_HOME/configs/ssh/.ssh/$_srv_key.pub ]]; then 
		echo "please generate a ssh key identified by name ($_srv_key)."
		echo "you can use the following command: cmd ssh key"
		echo 
	fi

	echo "please copy the ssh key pub to the remote server"
	echo "you can use the following command: cmd ssh copyid $_srv_connection"
	echo 
}

function _ssh_srv_con_(){
	if [[ -f $_COMMANDER_HOME/configs/ssh/$1.sh ]]; then 		
		host=${1}_host
		port=${1}_port
		user=${1}_user
		eval ssh \$$user@\$$host -p \$$port
	else
		echo "ssh connection ($1) doesn't exist."
	fi 
}

function _ssh_key_cpy_(){
	if [[ ! -f $_COMMANDER_HOME/configs/ssh/$1.sh ]]; then 		
		echo "ssh connection ($1) doesn't exist. please use command: cmd ssh con"
		return
	fi 

	host=${1}_host
	port=${1}_port
	user=${1}_user
	key=${1}_key
	eval ssh-copy-id -i $_COMMANDER_HOME/configs/ssh/.ssh/\$$key.pub \$$user@\$$host -p \$$port
}

_ssh_agent_
_ssh_key_load_

function cmd-ssh(){
	__doc__  ssh key and connection management
	case "$1" in
	"" | -h )
		echo "Usage: cmd-ssh [ key | connect(con | conn) | copyid(copy) | list(ls) | reload ]"
		echo
		;;
	"key" )
		shift
		if [[ $# -gt 0 ]]; then
			_ssh_key_pub_ $1
		else
			_ssh_key_gen_
		fi	
	;;
	"con" | "conn" | "connect" )
		shift
		if [[ $# -eq 1 ]]; then
			_ssh_srv_con_ $1
		else
			_ssh_srv_new_
		fi
	;;
	"copyid" | "copy" )
		shift
		if [[ $# -ne 1 ]]; then
			echo "Usage: cmd ssh copyid [connection]"
			echo
			return
		fi
		_ssh_key_cpy_ $@		
	;;
	"list" | "ls" )
		if [[ -d $_COMMANDER_HOME/configs/ssh ]]; then
			echo "ssh command has following connections:"
			echo
			for file in $(find "$_COMMANDER_HOME/configs/ssh" -name "*.sh"); do
				filename=${file##*/}
				echo ${filename%%.sh}
			done | sort | uniq	
		fi

		echo

		if [[ -d $_COMMANDER_HOME/configs/ssh/.ssh ]]; then
			echo "ssh command has following keys:"
			echo
			for file in $(find "$_COMMANDER_HOME/configs/ssh/.ssh" -name "*.pub"); do
				filename=${file##*/}
				echo ${filename%%.pub}
			done | sort | uniq	
		fi
		
	;;
	"remove" )
		shift
		if [[ $# -gt 0 ]]; then
			_ssh_key_del_ $1
		fi
	;;
	"reload" )
		shift
		_ssh_key_load_ $@
	;;
	* )
		if [[ ! -f $_COMMANDER_HOME/configs/ssh/$1.sh ]]; then 		
			echo "connection ($1) not exist."
		fi
		_ssh_srv_con_ $1
	;;
	esac	
}
complete -W "key connect copyid list remove reload" cmd-ssh
