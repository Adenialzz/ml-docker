alias c="clear"
alias nv="watch -n -0.5 nvidia-smi"
alias lt="ls -lrt"
alias JJ="conda activate JJ_env"
alias py="python"
alias vi="nvim"
alias sc="source /root/.zshrc"
alias pips-thu="pip install -i https://pypi.tuna.tsinghua.edu.cn/simple"
alias hss="history | grep"

if [ `uname -s` = Darwin ]; then
	alias pss="ps -ax | grep -v "grep" | grep -v "pss" | grep --color=auto"
elif [ `uname -s` = Linux ]; then
	alias pss="ps -aux | grep -v "grep" | grep -v "pss" | grep --color=auto"
fi

