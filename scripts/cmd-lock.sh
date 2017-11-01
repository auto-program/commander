#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ lock

function cmd-lock(){
	__doc__ lock screen command for mac
	_exec_ /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}
