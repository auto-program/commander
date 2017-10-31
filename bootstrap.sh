#!/bin/bash
if [[ "$BASH_SOURCE[0]" == "" ]]; then
	export _COMMANDER_HOME=$(cd $(dirname $0) 2>&1 >/dev/null; pwd)
else
	export _COMMANDER_HOME=$(cd $(dirname $BASH_SOURCE[0]) 2>&1 >/dev/null; pwd)
fi

. $_COMMANDER_HOME/libs/util.sh

#_debug_on_

# configs
if [[ ! -d $_COMMANDER_HOME/configs ]]; then
	_exec_ mkdir -p $_COMMANDER_HOME/configs
	echo "directory created[$_COMMANDER_HOME/configs]"
fi

# scripts
if [[ ! -d $_COMMANDER_HOME/scripts ]]; then
	_exec_ mkdir -p $_COMMANDER_HOME/scripts
	echo "directory created[$_COMMANDER_HOME/scripts]"
fi

# editor
read -p "please input your editor [default: vi]: " editor
if [[ $editor == "" ]]; then
	editor=vi
fi

# configs/setup.sh
_cf_var_write_ "setup.sh" "editor" $editor

# volumns
read -p "please input your data root directory [default: $_COMMANDER_HOME/volumns]: " data_dir
if [[ $data_dir == "" ]]; then
	data_dir=$_COMMANDER_HOME/volumns
fi

# symbol link
if [[ ! -d $_COMMANDER_HOME/volumns ]]; then
	if [[ $data_dir != "$_COMMANDER_HOME/volumns" ]]; then 
		if [[ ! -d $data_dir ]]; then 
			_exec_ mkdir -p $data_dir
			echo "directory created [$data_dir]."
		fi
		_exec_ ln -s $data_dir $_COMMANDER_HOME/volumns
		echo "symbol linked the directory [$_COMMANDER_HOME/volumns] to [$data_dir]."
	else
		_exec_ mkdir -p $_COMMANDER_HOME/volumns
		echo "directory created [$data_dir]."
	fi
fi

# brew
_check_ "brew"
ret=$?
if [[ "$ret" == "1" ]]; then 
	echo "install [brew]..."
	_exec_ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	echo "install [brew]...ok"
fi

# note
echo 
echo "============================================================"
echo " NOTE "
echo "============================================================"
echo "please execute: "
echo "    echo 'source $_COMMANDER_HOME/command.sh' >> ~/.bash_profile"
echo "    source ~/.bash_profile"
echo "or for zsh: "
echo "    echo 'autoload bashcompinit' >> ~/.zshrc"
echo "    echo 'bashcompinit' >> ~/.zshrc"
echo "    echo 'source $_COMMANDER_HOME/command.sh' >> ~/.zshrc"
echo "    source ~/.zshrc"
echo "run \"cmd help\" to print all available functions"