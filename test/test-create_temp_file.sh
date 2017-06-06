set -e
#set -x

source ../file-util.sh

declare temp_file_name
create_temp_file temp_file_name
echo "temp_file_name=${temp_file_name}"
if [ -e ${temp_file_name} ]; then
    echo "File ${temp_file_name} exists"
else
    echo "File ${temp_file_name} does not exist"
fi

# end with different results and verify file does not exist

# exit with error condition
# exit 1

# exit with success condition
exit 0
