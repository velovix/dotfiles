mkdir -p ~/sh

# Install antigen if necessary
if [ ! -d ~/sh/antigen ]; then
	echo "Installing antigen..."
	git clone https://github.com/zsh-users/antigen ~/sh/antigen
fi

# Install z if necessary
if [ ! -d ~/sh/z ]; then
	echo "Installing z..."
	git clone https://github.com/rupa/z ~/sh/z
fi

# Turn on antigen
source ~/sh/antigen/antigen.zsh

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

# We're finished making changes
antigen apply

# Turn on direnv
if hash direnv 2>/dev/null; then
	eval "$(direnv hook zsh)"
else
	echo "Warning: direnv is not installed"
fi

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

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
if hash virtualenvwrapper.sh 2>/dev/null; then
	source virtualenvwrapper.sh
else
	echo "Warning: virtualenvwrapper is not installed"
fi

if hash nvim 2>/dev/null; then
	export EDITOR=nvim
else
	export EDITOR=vi
fi

if [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
else
	echo "Warning: fzf is not installed"
fi
