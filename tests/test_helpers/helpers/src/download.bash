download_status_code_to_file() {
	local url="${1}"
	local output_file="${2}"
	wget --spider --server-response "${url}" 2>&1 | nawk '(match($0,"HTTP/1\.1")) {print $2}' | tail --lines 1 >>"${output_file}"
}

download_status_code_to_stream() {
	local url="${1}"
	wget --spider --server-response "${url}" 2>&1 | nawk '(match($0,"HTTP/1\.1")) {print $2}' | tail --lines 1
}

mock_download_func_to_use_stored_data() {
	local download_func_name="$1"
	save_function "$download_func_name" "_$download_func_name"
	mocked_func() {
		local url="$1"
		local file
		if [ $# == 2 ]; then
			local output_mode="file"
			local output_path="$2"
			file=$(basename "$2")
		else
			local output_mode="stream"
			file=$(basename "$url")
		fi
		local data_path="$DATA_DIR/$file"
		if [ $output_mode = "file" ]; then
		    if [ -f "$data_path" ]; then
            cp "$data_path" "$output_path"
        else
            eval "_$download_func_name $*"
            cp "$output_path" "$data_path"
        fi
    else
        if [ ! -f "$data_path" ]; then
            eval "_$download_func_name $*" > "$data_path"
        fi
        cat "$data_path"
    fi
	}
	save_function mocked_func "$download_func_name" "download_func_name=$download_func_name" && unset -f mocked_func
}
