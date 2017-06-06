[ ${STRING_UTIL_FLAG:-0} -gt 0 ] && return 0

export STRING_UTIL_FLAG=1


function trim() {
    shopt -s extglob
    local -n astring="${1}"
    astring="${astring/#+( )}"
    astring="${astring/%+( )}"
}

