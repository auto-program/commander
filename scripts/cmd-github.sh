#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ "github"

_check_ "git"
ret=$?
if [[ "$ret" == "1" ]]; then 
	echo "brew installing git ..."
	_exec_ brew install git
	echo "brew installing git ... ok."
fi

if [[ ! -d $_COMMANDER_HOME/volumns/github ]]; then
	_exec_ mkdir $_COMMANDER_HOME/volumns/github
	echo "directory created ["$_COMMANDER_HOME/volumns/github"]"
fi 

function _cmd_github_username_() {
	pwd=$(pwd)
	n=$(echo ${pwd#$_COMMANDER_HOME/volumns/github/})
	echo $n | awk -F'/' '{print $1}'
}

function _cmd_github_setup_(){
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
	echo -n "git ssh key: "
	read key
	if [[ "$key" == "" ]]; then
		echo "git ssh key can't empty"
		return
	fi

	username=$(_cmd_github_username_)
	if [[ $username == "" ]]; then
		_cf_var_write_ "github/setup.sh" "github_ssh_key" $key
		_cf_append_ "github/setup.cf" "git config --local user.name "\"$name\"
		_cf_append_ "github/setup.cf" "git config --local user.email "\"$email\"
		_cf_append_ "github/setup.cf" "git commit --amend --reset-author"
	else
		_cf_var_write_ "github/${username}/setup.sh" "github_${username}_ssh_key" $key
		_cf_append_ "github/${username}/setup.cf" "git config --local user.name "\"$name\"
		_cf_append_ "github/${username}/setup.cf" "git config --local user.email "\"$email\"	
		_cf_append_ "github/${username}/setup.cf" "git commit --amend --reset-author"
	fi

	if [[ ! -f $_COMMANDER_HOME/configs/ssh/.ssh/$key ]]; then
		_ssh_key_gen_ $key
	fi
}

function _cmd_github_config_(){
	username=$(_cmd_github_username_)
	if [[ -f $_COMMANDER_HOME/configs/github/$username/setup.cf ]]; then
		cat $_COMMANDER_HOME/configs/github/$username/setup.cf
	fi
}

function _cmd_github_switch_(){
	
	_cf_bash_ "github" $@ "setup.cf"
}

function cmd-github(){
	__doc__ github user and repo management

	case "$1" in
	"" )
		cd $_COMMANDER_HOME/volumns/github
		_cf_bash_ "github" "setup.cf"
		;;
	"help" | -h )
		echo "Usage: cmd-github [setup | config | (username | organization | repository)]"
		echo
		;;
	"setup" )
		_cmd_github_setup_
		;;
	"config" )
		echo "current git user name:"$(git config user.name)
		echo "current git user email:"$(git config user.email)
		;;
	* )
		# switch root
		cd $_COMMANDER_HOME/volumns/github
		_cf_bash_ "github" "setup.cf"

		# 判断当前目录 username
		for user in $(ls $_COMMANDER_HOME/volumns/github) ; do
			if [[ -d $_COMMANDER_HOME/volumns/github/$user ]]; then
				if [[ $user == $1 ]]; then
					cd $_COMMANDER_HOME/volumns/github/$user
					return
				fi
			fi			
		done

		# 判断当前目录 repository
		for user in $(ls $_COMMANDER_HOME/volumns/github) ; do
			for repo in $(ls $_COMMANDER_HOME/volumns/github/$user) ; do
				if [[ -d $_COMMANDER_HOME/volumns/github/$user/$repo ]]; then
					if [[ $repo == $1 ]]; then
						cd $_COMMANDER_HOME/volumns/github/$user/$repo
						eval _ssh_key_load_ \$github_${user}_ssh_key
						_cf_bash_ "github" $user "setup.cf"
						return
					fi
				fi
			done
		done

		# create a new user
		echo -n "Do you want create a new user(organization) ($1): [Y/n]"
		read n
		if [[ $n == "" ]] || [[ $n == "y" ]] || [[ $n == "Y" ]]; then
			mkdir $_COMMANDER_HOME/volumns/github/$1
			echo "directory created: $_COMMANDER_HOME/volumns/github/$1"
			cd $_COMMANDER_HOME/volumns/github/$1
		fi
		;;
	esac	
}

complete -W "setup config" cmd-github
