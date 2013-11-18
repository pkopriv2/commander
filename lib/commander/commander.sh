#! /usr/bin/env bash

require 'lib/bashum/lang/fail.sh'

require 'lib/commander/cli/command.sh'
require 'lib/commander/cli/console.sh'
require 'lib/commander/cli/options.sh'

require 'commands/help.sh'
require 'commands/version.sh'

# usage: commander_run [<arg>]*
commander_run() {

	# if no args are provided, then go to the help menu
	if (( $# == 0 ))
	then
		help
		exit $?
	fi

	# see if the user was aiming for general help
	if options_is_help $@
	then
		shift 

		help "$@"
		exit $?
	fi

	# see if the user was aiming for the version
	if options_is_version $@ 
	then
		shift

		version "$@" 
		exit $?
	fi

    # set the separator
    _IFS=$IFS; IFS=$'\n'

	# try to get the command
	if ! cmd_tuple=( $(command_get_from_args "$@" ) ) 
	then
		error "Unabe to locate command for args: $*"
		echo 

		help 
		exit 1
	fi

    # reset the separator
    IFS=$_IFS

	# load the command
	source ${cmd_tuple[0]}

	# see if the user was aiming for help with the command
	if options_is_help ${cmd_tuple[@]:1}
	then
		command_help ${cmd_tuple[0]}
		exit $?
	fi
    
	# execute the command
	$(command_get_main_fn ${cmd_tuple[0]}) "${cmd_tuple[@]:1}"
	exit $?
}

