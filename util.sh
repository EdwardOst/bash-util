[ "${UTIL_FLAG:-0}" -gt 0 ] && return 0

export UTIL_FLAG=1



#
# define
#
# pretty print define function for reading here documents into a variable
# then use a here string to access it elsewhere
#
# example
# create a template using here document
# backtick allows commands or functions to inject derived content
#
# define my_template <<-EOF
# 	function ${my_func}() {
#	    echo "executing ${my_func}"
#	    `typeset -p my_dictionary`
#	}
#	EOF

define(){ IFS='\n' read -r -d '' "${1}" || true; }




# echo message only if DEBUG_LOG variable is set

function debugLog() { 
    if [ -n "${DEBUG_LOG}" ] ; then
        cat <<< "${FUNCNAME[*]}: ${@}" 1>&2
    fi
}


# echo message to log

function infoLog() { 
    cat <<< "${FUNCNAME[*]}: ${@}" 1>&2
}


# echo a variable if DEBUG_LOG is set, pass variable name without $ as arg

function debugVar() {
    if [ -n "${DEBUG_LOG}" ] ; then
        cat <<< "${FUNCNAME[*]}: ${1}=${!1}" 1>&2
    fi
}


# echo a variable to the log, pass variable name without $ as arg

function infoVar() {
    cat <<< "${FUNCNAME[*]}: ${1}=${!1}" 1>&2
}


# print the current call stack to stderr

function debugStack() {
	if [ -n "${DEBUG_LOG}" ] ; then
		[ "${#}" -gt 0 ] && __tag=": $@"
		cat <<< "debug: ${FUNCNAME[*]}${__tag}" 1>&2
	fi
}


# print the current call stack

function infoStack() {
    [ "${#}" -gt 0 ] && __tag=": $@"
    cat <<< "${FUNCNAME[*]}${__tag}" 1>&2
}


# send message to stderr

function yell() { echo "$0: $*" >&2; }


# send message to stderr and exit

function die() { yell "$*"; exit 111; }


# exit if the command is not completed successfully

function try() { "$@" || die "cannot $*"; }


#
# set a variable that by convention is the name of the parent function
# prefixed with "_" and appended with "_result"
#
# usage
#	result _myVar
#

# function result() { eval _${FUNCNAME[1]}_result='"${!1}"'; }


function assign() {
    [ "${#}" -lt 2 ] && echo "usage: assign <var_name> <value>" && exit 1
    local -n var="${1}"
    var="${2}"
    debugVar "${!var}"
}


trap_add() {
    if [ "${1}" = "-h" -o "${1}" = "--help" -o "${#}" -lt 2 ] ; then
        cat <<-HELPDOC
	  DESCRIPTION

	  USAGE
	    trap_add <handler> <signal>

	    parameter: handler: a command or usually a function used as a signal handler
            parameter: signal: one or more trappable SIGNALS to which the handler will be attached
	HELPDOC
        return 2
    fi

    local _trap_command="${1}"
    shift 1
    local _trap_signal
    for _trap_signal in "$@"; do
        debugVar _trap_signal

        # Get the currently defined traps
        debugLog $(trap -p "${_trap_signal}" | awk -F"'" '{print "${2}"}')
        local _existing_trap=$(trap -p "${_trap_signal}" | awk -F"'" '{print "${2}"}')

        # Remove single apostrophe formatting wrapper
        _existing_trap="${_existing_trap#\'}"
        _existing_trap="${_existing_trap%\'}"
        debugVar _existing_trap

        # Append new trap to old trap
        [ -n "${_existing_trap}" ] && _existing_trap="${_existing_trap};"
        local _new_trap="${_existing_trap}${_trap_command}"
        debugVar _new_trap

        # Assign the composed trap
         trap "${_new_trap}" "${_trap_signal}"
    done
}

# set the trace attribute for the above function.  this is
# required to modify DEBUG or RETURN traps because functions don't
# inherit them unless the trace attribute is set
declare -f -t trap_add


# load/export deals with variables
# read/write deals with property files

export -f define
export -f debugLog
export -f debugVar
export -f infoLog
export -f infoVar
export -f debugStack
export -f infoStack
export -f yell
export -f die
export -f try
# export -f result
export -f assign
export -f trap_add

debugLog "sourced: util.sh"
