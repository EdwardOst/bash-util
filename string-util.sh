[ ${STRING_UTIL_FLAG:-0} -gt 0 ] && return 0

export STRING_UTIL_FLAG=1


function trim() {
    local -n astring="${1}"
    astring="${astring##[[:space:]]}"
    astring="${astring%%[[:space:]]}"
}

