set -e
# set -x

script_path=$(readlink -e "${BASH_SOURCE[0]}")
script_dir="${script_path%/*}"

util_path=$(readlink -e "${script_dir}/../util.sh")
source "${util_path}"

url_path=$(readlink -e "${script_dir}/../url.sh")
source "${url_path}"

repo_path=$(readlink -e "${script_dir}/../repo.sh")
source "${repo_path}"

[ $# -lt 2 ] && echo "username and password arguments required" && exit 1

userid=$1
password=$2

#download_file \
#    "http://www.opensourceetl.net/tis/tpdsbdrt_621/Talend-JobServer-20160704_1411-V6.2.1.zip" \
#    "./downloads" \
#    "${userid}" \
#    "${password}"

#download_manifest "talend-6.2.1.cfg" \
#    "./downloads" \
#    "${userid}" \
#    "${password}"

download_parallel "talend-6.2.1.cfg" \
    "./downloads" \
    "${userid}" \
    "${password}"

checksum "./downloads"
