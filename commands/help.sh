require 'lib/commander/cli/console.sh'
require 'lib/bashum/project_file.sh' 

help() {
	local name=$(project_file_get_name "$project_root/project.sh")
	local description=$(project_file_get_description "$project_root/project.sh")

	bold "${name^^} HELP"

	echo 
    echo "        $description"
	echo

	bold "COMMANDS"
	echo

	local commands=( $(command_get_all) )
	for file in ${commands[@]}
	do
		if [[ $file = *help.sh ]] 
		then
			continue
		fi

		source $file

		local fn=$(command_get_usage_fn $file)
		if ! declare -f $fn &>/dev/null
		then
			continue
		fi

        echo  "        $($fn)"
	done
	echo 
}
