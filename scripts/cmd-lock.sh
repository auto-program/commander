#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ lock

function cmd-lock(){
	__doc__ Mac 锁屏
	_exec_ /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}
