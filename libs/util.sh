#!/bin/bash

# error msg
function _error_() {
	echo "error: $1"
}

function _debug_on_(){
	export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
	set -x
}

function _debug_off_(){
	set +x
}

# check arguments(commands) exist
function _check_() {
	for i in $@ ; do
		if [ -z "$(command -v $i)" ]; then
			_error_ "command ($i) not installed."
			return 1
		fi
	done
	return 0
}

# 执行脚本或命令失败时 停止继续执行
function _exec_() {
	$@
	ret=$?
	if [[ "$ret" == "0" ]]; then
		return 0
	fi
	exit $ret
}

# source folder scripts
function _include_(){
	if [ -z "$(ls $1)" ]; then
		return
	fi
	for f in $1/*; do 
		. $f
	done
}

function _folder_(){
	echo $(basename $(pwd))
}

function _volumn_init_(){
	volumn_dir=$_COMMANDER_HOME/volumns
    for d in $@ ; do
		volumn_dir=$volumn_dir/$d
		if [[ ! -d $volumn_dir ]]; then
			_exec_ mkdir -p $volumn_dir
		fi
    done
}

function _volumn_(){
	volumn_dir=$_COMMANDER_HOME/volumns
	for d in $@ ; do
		volumn_dir=$volumn_dir/$d
	done
	echo $volumn_dir
}

function _cf_load_(){
    cf_dir=$_COMMANDER_HOME/configs
    for d in $@ ; do
		if [[ $d == ".ssh" ]]; then
			return
		fi
        cf_dir=$cf_dir/$d
    done

    if [[ -d $cf_dir ]]; then
		for file in $(find "$cf_dir" -name "*.sh"); do
			source $file
		done
    fi     
}

function _cf_bash_(){
	cf_file=$_COMMANDER_HOME/configs
	for d in $@ ; do
		cf_file=$cf_file/$d
	done
	if [[ -f $cf_file ]]; then
		bash -e $cf_file
	fi
}

function _cf_var_write_(){
	cf_file=$_COMMANDER_HOME/configs/$1
	cf_dir=$(dirname $cf_file)
	# create dir
	if [[ ! -d $cf_dir ]]; then
		_exec_ mkdir -p $cf_dir
	fi
	# create/append file with variable
	if [[ ! -f $cf_file ]]; then
		touch $cf_file
		chmod +x $cf_file
		cat <<EOF >> $cf_file
#!/bin/bash

export $2=$3
EOF
	else
		echo "export $2=$3" >>$cf_file
	fi
}

function _cf_var_append_(){
	cf_file=$_COMMANDER_HOME/configs/$1
	cf_dir=$(dirname $cf_file)
	# create dir
	if [[ ! -d $cf_dir ]]; then
		_exec_ mkdir -p $cf_dir
	fi
	# create/append file with variable
	if [[ ! -f $cf_file ]]; then
		touch $cf_file
		chmod +x $cf_file
		cat <<EOF >> $cf_file
#!/bin/bash

export $2=\$$2:$3
EOF
	else
		echo "export $2=\$$2:$3" >>$cf_file
	fi
}

function _cf_append_(){
	cf_file=$_COMMANDER_HOME/configs/$1
	cf_dir=$(dirname $cf_file)
	# create dir
	if [[ ! -d $cf_dir ]]; then
		mkdir -p $cf_dir
		echo mkdir -p $cf_dir
	fi
	shift
	# create/append file with variable
	if [[ ! -f $cf_file ]]; then
		touch $cf_file
		chmod +x $cf_file
		cat <<EOF >> $cf_file
#!/bin/bash

$@
EOF
	else
		echo $@ >>$cf_file
	fi
}