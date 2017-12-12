#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ go

if [[ ! -d $_COMMANDER_HOME/volumns/go ]]; then
	_exec_ mkdir $_COMMANDER_HOME/volumns/go
	echo "directory created ["$_COMMANDER_HOME/volumns/go"]"
fi 

function cmd-go(){
	__doc__ Go环境设置
	case "$1" in
	"" )
		cd $_COMMANDER_HOME/volumns/go
		;;
	"setup" )
		export GOPATH=$_COMMANDER_HOME/volumns/go
		if [[ ! -d $_COMMANDER_HOME/volumns/go/src ]]; then
			mkdir $_COMMANDER_HOME/volumns/go/src
			ln -s $_COMMANDER_HOME/volumns/github $_COMMANDER_HOME/volumns/go/src/github.com 
		fi
		;;
	"clear" )
		export GOPATH=
		;;
	esac	
}
