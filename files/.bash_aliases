alias install='sudo apt install -y'
alias gicam='git commit -am'
alias gitus='git status'
alias gico='git checkout'
alias gicob='gico -b'
alias .bash='source $HOME/.bashrc'

function gipam {
	gicam "$1" && git push
}
function gipamu {
	local current_branch=$(git branch --show-current)
	echo "Set $current_branch as upstream branch"
	gicam "$1" && git push -u origin "$current_branch"
}
