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

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# We're finished making changes
antigen apply

