#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ reboot

function cmd-reboot(){
	__doc__ reboot command for mac
	sudo shutdown -r now
}
