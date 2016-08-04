# This should include configuration I would want on any machine, so not
# something specific to, say, work. Platform-specific info should be in a file
# in profiles/ and sourced in the home directory ".platform-profile".

# Set XDG directories
export XDG_DOCUMENTS_DIR="$HOME/documents"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/pictures"
export XDG_DESKTOP_DIR="$HOME/desktop"

# Source the platform-specific profile
source $HOME/.platform-profile
