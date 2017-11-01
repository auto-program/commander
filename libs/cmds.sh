#!/bin/bash

function _cmd_complete() {
  COMPREPLY=( $(compgen -W "$(cmd-list)" -- "$word") )
}

function _cmd_version_(){
    export _COMMANDER_VERSION=0.0.3
    echo "commander [cmd] version $_COMMANDER_VERSION"
}

function cmd-help(){
    __doc__ help
    _cmd_show_logo_
    echo   
    _cmd_version_
    echo  
	declare -f | egrep '^cmd-\w+' -A 1 | awk 'BEGIN{name=""; doc=""} /--/ {print name"\t"doc; doc=""; name=""} /__doc__/ {for(i=2;i<=NF;i++) doc=doc" "$i} /\(\)/ {name=$1} END{print name"\t"doc}' | column -t -s "	"| sort 
}

function cmd-add(){
    __doc__ add a custom command
    command="$1"
	case "$command" in 
	"" )
		_error_ "command name absent."
	;;
	"help" | "setup" | "exit" )
		_error_ "$1 reserved."
	;;
	* )
		command_path=$_COMMANDER_HOME/scripts/cmd-$command.sh
		if [ -e "$command_path" ]; then
	    	echo "warn: $command already exist."
	    	return	
	    fi
	    shift
	    touch $command_path
	    chmod +x $command_path
		cat <<EOF >> $command_path
#!/bin/bash

. \$_COMMANDER_HOME/libs/util.sh

_cf_load_ $command

function cmd-$command(){
	__doc__ $@
	echo 'please complete command: $command'
}
EOF
	    source $command_path
	;;
	esac
}

function cmd-edit(){
    __doc__ edit a custom command
    if [[ $editor == "" ]]; then
        export editor=vi
    fi

	if [[ $# -eq 0 ]]; then
		echo "Usage: cmd-edit [command-name | file-name]"
		echo "please input the command name or file name."
		echo 
		return
	fi

    if [ -e $_COMMANDER_HOME/scripts/cmd-$1.sh ]; then
        _exec_ $editor $_COMMANDER_HOME/scripts/cmd-$1.sh    
    else
        if [[ ! -f $(pwd)/$1 ]]; then
			touch $(pwd)/$1
		fi
		_exec_ $editor $(pwd)/$1
    fi 
}

function cmd-del(){
    __doc__ remove a custom command
    mkdir -p $_COMMANDER_HOME/scripts/rms
	for i in $@ ; do
		if [ -e $_COMMANDER_HOME/scripts/cmd-$i.sh ]; then
			rm -rf $_COMMANDER_HOME/configs/$1
			rm -rf $_COMMANDER_HOME/volumns/$1
			unset -f cmd-$i
			mv $_COMMANDER_HOME/scripts/cmd-$i.sh $_COMMANDER_HOME/scripts/rms/$i
			echo "warn: remove command (cmd-$i)"
		fi

		if [ -f $(pwd)/$i ]; then
			rm $(pwd)/$i
			echo "warn: remove file ($(pwd)/$i)"
		fi
	done
}

function cmd-list(){
    __doc__ list all custom commands
    if [ -z "$(ls $_COMMANDER_HOME/scripts)" ]; then
		return
	fi
	for file in $(find "$_COMMANDER_HOME/scripts" -name "*.sh"); do
	  command="${file##*cmd-}"
	  echo ${command%.sh}
	done | sort | uniq	
}

#initialize
function _cmd_initialize_(){
	if [[ "$_cmd_inited_" != "1" ]]; then
        cmd-help
	fi
	export _cmd_inited_=1
    _cf_load_
}

function _cmd_show_logo_(){
    echo
    echo "	                                                  __         "
    echo "	  _________  ____ ___  ____ ___  ____ _____  ____/ /__  _____"
    echo "	 / ___/ __ \/ __ \__ \/ __ \__ \/ __ \/ __ \/ __  / _ \/ ___/"
    echo "	/ /__/ /_/ / / / / / / / / / / / /_/ / / / / /_/ /  __/ /    "
    echo "	\___/\____/_/ /_/ /_/_/ /_/ /_/\__,_/_/ /_/\__,_/\___/_/     "
    echo
}
