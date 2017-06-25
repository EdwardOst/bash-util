[ "${USER_UTIL_FLAG:-0}" -gt 0 ] && return 0

export USER_UTIL_FLAG=1

user_util_script_path=$(readlink -e "${BASH_SOURCE[0]}")
user_util_script_dir="${user_util_script_path%/*}"

user_util_string_path=$(readlink -e "${user_util_script_dir}/string-util.sh")
source "${user_util_string_path}"


function user_exists() {
    [ "${#}" -lt 1 ] && echo "ERROR: usage: user_exists <user>" && return 1
    local user="${1}"
    trim user
    [ -z "${user}" ] && echo -e "ERROR: usage: user_exists <user>\nempty user argument" && return 1

    id -u "${user}" > /dev/null 2>&1

    return "${?}"
}



function group_exists() {
    [ "${#}" -lt 1 ] && echo "ERROR: usage: group_exists <group_name>" && return 1
    local group_name="${1}"
    trim group_name
    [ -z "${group_name}" ] && echo -e "ERROR: usage: group_exists <group_name>\nempty group_name argument" && return 1

    getent group | cut -d: -f1 | grep "^${group_name}$" > /dev/null 2>&1

    return "${?}"
}

function group_members() {
    [ "${#}" -lt 2 ] && echo "ERROR: usage: group_members <group_name> <member_list_ref>" && return 1
    local group_name="${1}"
    trim group_name
    [ -z "${group_name}" ] && echo -e "ERROR: usage: group_members <group_name>\nempty group_name argument" && return 1

    local -n member_list="${2}"

#    member_list=$(getent group | grep "^${group_name}:" | cut -d: -f4)
    local members=$(getent group | grep "^${group_name}:" | cut -d: -f4)
    IFS=', ' read -r -a member_list <<< "${members}"
}
