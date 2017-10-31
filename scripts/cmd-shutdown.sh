#!/bin/bash

. $_COMMANDER_HOME/libs/util.sh

_cf_load_ shutdown

function cmd-shutdown(){
	__doc__ Mac 关机
	sudo shutdown -h now
}
