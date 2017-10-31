#!/bin/bash
if [[ "$BASH_SOURCE[0]" == "" ]]; then
	export _COMMANDER_HOME=$(cd $(dirname $0) 2>&1 >/dev/null; pwd)
else
	export _COMMANDER_HOME=$(cd $(dirname $BASH_SOURCE[0]) 2>&1 >/dev/null; pwd)
fi

. $_COMMANDER_HOME/libs/util.sh

#入口函数
function cmd(){
    # include system commands
    . $_COMMANDER_HOME/libs/cmds.sh

    # include custom commands
    _include_ "$_COMMANDER_HOME/scripts"
    
    # init
    _cmd_initialize_

    # command
    command="$1"
	case "$command" in 
	"" )
		cd $_COMMANDER_HOME
	;;
	-v | --version )
		_cmd_version_
		;;
    "help" | "-h" )
        cmd-help
        ;;
	"add" )
		shift
		cmd-add $@
		;;
    "edit" )
		shift
		cmd-edit $@
		;;
	"del" )
		shift
		cmd-del $@
		;;
    "list" | "ls" | "-l" )
		shift
		cmd-list $@
		;;
	* )
		command_path=$_COMMANDER_HOME/scripts/cmd-$command.sh
		if [ -x "$command_path" ]; then
			. $command_path
			shift
			_exec_ cmd-$command $@
			return 
		fi
		
		echo "unsupport command: $command"
	esac
}

# complete cmd
complete -F _cmd_complete cmd

