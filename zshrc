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

# Set XDG directories
export XDG_DOCUMENTS_DIR="$HOME/documents"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/pictures"
export XDG_DESKTOP_DIR="$HOME/desktop"

# We're finished making changes
antigen apply

