[ "${FILE_UTIL_FLAG:-0}" -gt 0 ] && return 0

export FILE_UTIL_FLAG=1

file_util_script_path=$(readlink -e "${BASH_SOURCE[0]}")
file_util_script_dir="${file_util_script_path%/*}"

file_util_util_path=$(readlink -e "${file_util_script_dir}/util.sh")
source "${file_util_util_path}"


create_temp_file() {
    [ "${#}" -lt 1 ] && echo "usage: create_temp_file <file_name_ref>" && return 1
    local -n temp_file="${1}"
    temp_file=$(mktemp)
    trap_add "rm -f ${temp_file}" EXIT
}


create_temp_dir() {
    [ "${#}" -lt 1 ] && echo "usage: create_temp_dir <dir_ref>" && return 1
    local -n temp_dir="${1}"
    temp_dir=$(mktemp -d)
    trap_add "rm -rf ${temp_dir}" EXIT
}


function create_user_directory() {

    if [ "${1}" = "-h" -o "${1}" = "--help" -o "$#" -lt 1 ] ; then
        cat <<-HELPDOC
	create_user_directory

	    DESCRIPTION
	        Create a user owned directory as sudo in some arbitrary location,
	        and change the owner and group of the leaf node directory and any
	        new intermediate directories created in the process.
	        existing directoryies are not modified.

	    CONSTRAINTS
	        Assumes access to sudo.

	    USAGE:
	        create_user_directory <fullDirPath> [ <owner> [ <group> ] ]

	        parameter: fullDirPath: required
	        parameter: owner: defaults to installUser config or current user if not defined
	        parameter: group: defaults to installGroup config or current group if not defined

	HELPDOC
        return 1
    fi

    local fullDirPath="${1}"

    [ -z "${fullDirPath}" ] && echo "Invalid file path: ${fullDirPath}" && return 1

    local parentDir=$(dirname "${fullDirPath}")

    # if dirname failed then exit
    [ "$?" -ne 0 ] && echo "Error parsing parent directory: ${fullDirPath}" && return 1

    local owner="${2:-${installUser:-$USER}}"
    local group="${3:-${installUser:-$(id -gn)}}"

    # todo: use iteration rather than recursion
    [ ! -d "${parentDir}" ] && create_user_directory "${parentDir}" "${owner}" "${group}"
    sudo mkdir -p "${fullDirPath}"
    sudo chmod g+rx "${fullDirPath}"
    sudo chown "${owner}:${group}" "${fullDirPath}"

}



export -f create_temp_file
export -f create_temp_dir
export -f create_user_directory
