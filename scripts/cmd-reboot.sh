#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ reboot

function cmd-reboot(){
	__doc__ Mac 重启
	sudo shutdown -r now
}
