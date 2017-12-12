#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_volumn_init_ goflow

_cf_load_ goflow

function _goflow_setup_(){
	echo -n "git user name: "
	read name
	if [[ "$name" == "" ]]; then
		echo "name can't empty"
		return
	fi
	echo -n "git user email: "
	read email
	if [[ "$email" == "" ]]; then
		echo "email can't empty"
		return
	fi
	
	_cf_append_ "goflow/$1/setup.cf" "git config --local user.name "\"$name\"
	_cf_append_ "goflow/$1/setup.cf" "git config --local user.email "\"$email\"	
	
	sshkey=goflow.$1
	if [[ ! -f $_COMMANDER_HOME/configs/ssh/.ssh/$sshkey ]]; then
		_ssh_key_gen_ $sshkey
	fi
}

function cmd-goflow(){
	__doc__ go flow switch command 
	case "$1" in
	"" | "help" | -h )
		echo "Usage: cmd-goflow [setup | (username | organization | repository)]"
		echo
		;;
	"setup" )
		if [[ $# -ne 2 ]]; then
			echo "warn: none name."
			return
		fi 
		shift
		_volumn_init_ goflow $1
		_goflow_setup_ $1
		;;
	* )
		if [[ -d $(_volumn_ $@) ]]; then
			_cf_bash_ goflow $1 "setup.cf"
			eval _ssh_key_load_ goflow.$1
			
			export GOPATH=$(_volumn_ $1)
			cd $(_volumn_ $@)
		else
			echo $1 "not exists."
		fi
		;;
	esac
}

complete -W "setup" cmd-goflow
