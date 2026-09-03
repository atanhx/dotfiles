export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:$HOME/.local/bin/bin:/opt/cuda-11.7/bin"
export PATH="$PATH:$HOME/dev/flutter/bin"
export PATH="$PATH:$HOME/dev/dotfiles/tmux-sessionizer/"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.bun/bin"
export LD_LIBRARY_PATH="/opt/cuda-11.7/lib64:$LD_LIBRARY_PATH"
export NVM_DIR="$HOME/.nvm"
export PATH="$PATH:$HOME/.opencode/bin"
export PATH="$PATH:$HOME.lmstudio/bin"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
export JAVA_HOME=/opt/android-studio/jbr
export ANDROID_HOME="$HOME/Android/Sdk"
export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"

export EDITOR="nvim"
export CHROME_EXECUTABLE="google-chrome-stable"

plugins=()

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

setopt HIST_IGNORE_SPACE

alias cd='z'
alias ls='ls -la'
alias l='ls -la'
alias ll='ls -la'
alias x='exit'
alias open='xdg-open'
alias deepclean='yay -Rns $(pacman -Qtdq) --noconfirm; yay -Scc --noconfirm'
alias n='nvim .'
alias v='nvim .'
alias vim='nvim .'
alias cat='bat -P --plain'
alias calc='qalc'
alias btop='btop --force-utf'
alias exiftool='/usr/bin/vendor_perl/exiftool'
alias tmux='tmux -u'
alias jrnl=" jrnl"
alias ytdirectdownload='yt-dlp -f "bestvideo[height<=1080]+bestaudio" --recode-video mkv --embed-thumbnail --write-subs --embed-subs "$@"'
alias activate='source $HOME/dev/base-env/bin/activate'
alias mirror_list_update='rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist'
alias google-chrome='google-chrome-stable'
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

if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

bindkey -s '^f' 'tmux-sessionizer\n'

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

xhost +local: >/dev/null 2>&1
