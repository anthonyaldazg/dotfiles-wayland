eval "$(starship init zsh)"

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Guardar el historial en un archivo
HISTFILE=~/.zsh_history

# Número de comandos a guardar en el historial
HISTSIZE=10000
SAVEHIST=10000

# Ignorar comandos duplicados y espacios en blanco
setopt hist_ignore_all_dups
setopt share_history

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
