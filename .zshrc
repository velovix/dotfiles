# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
# If not running interactively, don't do anything. Avoids running this when
# running a zsh script.
[[ -o interactive ]] || return

mkdir -p ~/.zsh_scripts

# Install antigen if necessary
if [ ! -d ~/.zsh_scripts/antigen ]; then
	echo "Installing antigen..."
	git clone https://github.com/zsh-users/antigen ~/.zsh_scripts/antigen
fi

# Install z if necessary
if [ ! -d ~/.zsh_scripts/z ]; then
	echo "Installing z..."
	git clone https://github.com/rupa/z ~/.zsh_scripts/z
fi

# Turn on antigen
source ~/.zsh_scripts/antigen/antigen.zsh

# Load the oh-my-zsh core library
antigen use oh-my-zsh

# Set up terminal colors
autoload -U colors && colors
setopt promptsubst

# Set the theme
antigen theme https://gist.github.com/9f73757ef2661989d9dd9d564560ced8.git cornlines

# Install plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle git
antigen bundle robbyrussell/oh-my-zsh plugins/extract
antigen bundle robbyrussell/oh-my-zsh plugins/golang
antigen bundle robbyrussell/oh-my-zsh plugins/z
antigen bundle zsh-users/zsh-autosuggestions

# We're finished making changes
antigen apply

# Use trash-cli instead of rm
if hash trash 2>/dev/null; then
	alias rm=trash
else
	echo "Warning: trash-cli is not installed"
fi

if [ "$TERM" = "linux" ]; then
    echo -en "\e]PB657b83" # S_base00
    echo -en "\e]PA586e75" # S_base01
    echo -en "\e]P0073642" # S_base02
    echo -en "\e]P62aa198" # S_cyan
    echo -en "\e]P8002b36" # S_base03
    echo -en "\e]P2859900" # S_green
    echo -en "\e]P5d33682" # S_magenta
    echo -en "\e]P1dc322f" # S_red
    echo -en "\e]PC839496" # S_base0
    echo -en "\e]PE93a1a1" # S_base1
    echo -en "\e]P9cb4b16" # S_orange
    echo -en "\e]P7eee8d5" # S_base2
    echo -en "\e]P4268bd2" # S_blue
    echo -en "\e]P3b58900" # S_yellow
    echo -en "\e]PFfdf6e3" # S_base3
    echo -en "\e]PD6c71c4" # S_violet
    clear # against bg artifacts
fi

export UBUNTU_VIRTUALENVWRAPPER="/usr/share/virtualenvwrapper/virtualenvwrapper.sh"

export VIRTUALENVWRAPPER_PYTHON=$(which python3)
if hash virtualenvwrapper.sh 2>/dev/null; then
	source virtualenvwrapper.sh
elif [[ -f "$UBUNTU_VIRTUALENVWRAPPER" ]]; then
	source "$UBUNTU_VIRTUALENVWRAPPER"
else
	echo "Warning: virtualenvwrapper is not installed"
fi

alias dd="dd status=progress"

if hash nvim 2>/dev/null; then
	export EDITOR=nvim
else
	export EDITOR=vi
fi

if [ -d "/usr/local/cuda/lib64" ]; then
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
fi

alias docker-killall='docker container stop $(docker container ls -aq) && docker container rm $(docker container ls -aq)'
alias bf='brainframe'
alias bfc='brainframe compose'
alias grepnt="grep --invert-match"
alias highlight='grep --color=always -z'

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin:~/.local/bin
export PATH=$PATH:~/.serverless/bin

chpwd() {
    ls --color=auto
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
