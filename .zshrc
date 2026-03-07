# =============================================================================
# 1. ENVIRONMENT & PATH
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin/bin:/opt/cuda-11.7/bin:$PATH"
export PATH="$PATH:$HOME/dev/projects/flutter/bin"
export LD_LIBRARY_PATH="/opt/cuda-11.7/lib64:$LD_LIBRARY_PATH"
export NVM_DIR="$HOME/.nvm"

# =============================================================================
# 2. OH-MY-ZSH CONFIG
# =============================================================================
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# 3. SETTINGS & PREFERENCES
# =============================================================================
setopt HIST_IGNORE_SPACE

# =============================================================================
# 4. ALIASES
# =============================================================================
# Navigation & Files
alias cd='z'
alias ls='ls -la'
alias l='ls -la'
alias ll='ls -la'
alias x='exit'
alias open='xdg-open'
alias deepclean='yay -Rns $(pacman -Qtdq) --noconfirm; yay -Scc --noconfirm'

# Editors & Viewing
alias n='nvim .'
alias v='nvim .'
alias vim='nvim .'
alias cat='bat -P --plain'

# Tools
alias calc='qalc'
alias btop='btop --force-utf'
alias exiftool='/usr/bin/vendor_perl/exiftool'
alias tmux='tmux -u'
alias jrnl=" jrnl"
alias ytdirectdownload='yt-dlp -f "bestvideo[height<=1080]+bestaudio" --recode-video mp4 --embed-thumbnail --write-subs --embed-subs "$@"'

# Dev / System
alias base_env='source ~/dev/base/bin/activate'
alias mirror_list_update='rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist'

# Git Aliases
alias gita='git add'
alias gitaa='git add --all'
alias gitb='git branch'
alias gitba='git branch -a'
alias gitc='git commit -m'
alias gitca='git commit --amend'
alias gitco='git checkout'
alias gitcb='git checkout -b'
alias gitd='git diff'
alias gitds='git diff --staged'
alias gitl='git log --oneline --graph --decorate'
alias gitp='git push'
alias gitpl='git pull'
alias gits='git status'

# =============================================================================
# 5. FUNCTIONS
# =============================================================================
wsync() {
    (
        sync &
        SYNC_PID=$!

        while kill -0 $SYNC_PID 2> /dev/null; do
            DIRTY_KB=$(grep "Dirty:" /proc/meminfo | awk '{print $2}')
            echo -ne "Syncing... $DIRTY_KB kB remaining\033[K\r"
            sleep 1
        done

        echo -e "\nSync Complete."
        notify-send "HDD Sync" "Write complete. Ready to unmount"
    )
}

# =============================================================================
# 6. TOOL INITIALIZATION
# =============================================================================

if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
