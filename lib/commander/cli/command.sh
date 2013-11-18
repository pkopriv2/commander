require 'lib/bashum/lang/fail.sh'
require 'lib/commander/cli/console.sh'

# usage: command_get_from_args <arg> [<arg>]*
command_get_from_args() {
	if (( $# < 1 ))
	then
		fail 'usage: command_get_from_args <arg> [<arg>]*' 
	fi

	local cur=$project_root/commands
	while (( $# > 0 ))
	do
		cur=$cur/$1; shift 
		if [[ -f "$cur".sh ]]
		then
			break
		fi

		if [[ ! -d $cur ]]
		then
			return 1
		fi
	done

	# ensure we've found it
	if [[ ! -f "$cur".sh ]]
	then
		return 1
	fi

	# okay, we found it.  emit the command.
	echo "$cur".sh

    # okay, now simply echo the remaining args
    while (( $# > 0 ))
    do
        echo "$1"; shift
    done
}

# usage: command_get_main_fn <file>
command_get_main_fn() {
	if (( $# != 1 ))
	then
		fail 'usage: command_get_main_fn <file>' 
	fi

	if [[ ! -f $1 ]]
	then
		fail "That command file [$1] does not exist"
	fi

	# remove the command home from the name 
	local remaining=${1##$project_root/commands/}
	local remaining=${remaining%%.sh}

	# okay, now split on "/" 
	local sub_dirs=( $( echo $remaining | sed 's|\/| |g' ) )

	# and finally, join with _
	local idx=0
	local size=${#sub_dirs[@]}

	while (( $idx < $size )) 
	do
		if (( $idx == $size-1 ))
		then
			echo -n "${sub_dirs[$idx]}"
			return 0
		fi

		echo -n "${sub_dirs[$idx]}_"
		let idx+=1
	done
}

# usage: command_get_usage_function <file>
command_get_usage_fn() {
	if (( $# != 1 ))
	then
		fail 'usage: command_get_usage_function <file>' 
	fi

	if [[ ! -f $1 ]]
	then
		fail "That command file [$1] does not exist"
	fi

	echo "$(command_get_main_fn $1)_usage"
}

command_default_usage() {
	if (( $# != 1 ))
	then
		fail 'usage: command_get_usage_function <file>' 
	fi

	if [[ ! -f $1 ]]
	then
		fail "That command file [$1] does not exist"
	fi

	echo "$(command_get_main_fn $1) [<arg>]*"
}

# description: command_get_description_function <file>
command_get_description_fn() {
	if (( $# != 1 ))
	then
		fail 'description: command_get_description_function <file>' 
	fi

	if [[ ! -f $1 ]]
	then
		fail "That command file [$1] does not exist"
	fi

	echo "$(command_get_main_fn $1)_description"
}

# options: command_get_options_function <file>
command_get_options_fn() {
	if (( $# != 1 ))
	then
		fail 'options: command_get_options_function <file>' 
	fi

	if [[ ! -f $1 ]]
	then
		fail "That command file [$1] does not exist"
	fi

	echo "$(command_get_main_fn $1)_options"
}

# usage: command_get_all <root_dir> 
command_get_all() {
	if (( $# != 0 ))
	then
		fail 'usage: command_get_all' 
	fi

	(
		find $project_root/commands -type f -name '*.sh'
	)
}

# usage: command_help <file>
command_help() { 
	if (( $# != 1 ))
	then
		fail 'usage: command_help <file>' 
	fi


	local usage_fn=$(command_get_usage_fn $1)
	if ! declare -f $usage_fn &>/dev/null
	then
		local usage_fn="command_default_usage $1"
	fi

	bold "USAGE"

	echo 
    echo "        $($usage_fn)"
	echo

	local description_fn=$(command_get_description_fn $1)
	if declare -f $description_fn &>/dev/null
	then
		bold "DESCRIPTION"

		echo 
		$description_fn
		echo
	fi

	local options_fn=$(command_get_options_fn $1)
	if declare -f $options_fn &>/dev/null
	then


		_IFS=$IFS; IFS=$'\n'

		bold "OPTIONS" 

		echo
		local options=( $( $options_fn ) )
		for option in ${options[@]} 
		do
			echo "        - $option"
		done
		echo

		IFS=$_IFS
	fi
}

