install_git_config() {
    git config --global user.email "cprevosteau@gmail.com"
    git config --global user.name "Clément PREVOSTEAU"
}

check_git_config() {
    [[ "$(git config --get --global user.email)" \
        == "cprevosteau@gmail.com" ]] && \
    [[ "$(git config --get --global user.name)" \
        == "Clément PREVOSTEAU" ]]
}
