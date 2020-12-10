alias install='sudo apt install -y'
alias gicam='git commit -am'
alias gitus='git status'
alias gico='git checkout'
alias gicob='gico -b'

function gipam {
	giciam "$1" && git push
}
function gipamu {
	CURRENT_BRANCH=`git branch --show-current`
	echo "Set $CURRENT_BRANCH as upstream branch"
	giciam "$1" && git push -u origin "$CURRENT_BRANCH"
}
