#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ doc

function cmd-doc(){
	__doc__ 文档管理
	if [[ ! -d $_COMMANDER_HOME/volumns/doc ]]; then
		mkdir $_COMMANDER_HOME/volumns/doc
	fi 

	cd $_COMMANDER_HOME/volumns/doc
}
