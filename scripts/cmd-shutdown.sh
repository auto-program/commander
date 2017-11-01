#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ shutdown

function cmd-shutdown(){
	__doc__ shutdown command for mac
	sudo shutdown -h now
}
