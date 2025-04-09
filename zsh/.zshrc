zmodload zsh/zprof

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

ZSH_FILES_DIRECTORY=$HOME/.zsh
for i in $ZSH_FILES_DIRECTORY/*; do
  source $i
done
# zprof
eval "$(atuin init zsh)"

# fnm
FNM_PATH="/home/destfu/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/destfu/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="/home/destfu/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/destfu/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/destfu/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
alias mamba=micromamba
alias conda=micromamba

alias l='ls -la'
alias cd..='cd ..'
alias zshrc='nvim ~/.zshrc'
alias reload='source ~/.zshrc'

