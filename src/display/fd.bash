##!/usr/bin/env bash

open_fd() {
    local fd_number="$1"
    local fd_file
    fd_file=$(tty)
    eval "exec $fd_number>$fd_file"

}

close_fd() {
    local fd_number="$1"
    eval "exec $fd_number>&-"
}