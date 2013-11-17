require 'lib/bashum/project_file.sh' 
require 'lib/commander/cli/console.sh'

version() {
	bold "VERSION"
	echo 

	project_file_get_version $project_root/project.sh
}
