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

