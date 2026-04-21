# ── 0. Instant Prompt & Cursor (Must be top) ────────────────────────
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PROFILING_MODE=0
if [ $PROFILING_MODE -ne 0 ]; then
    zmodload zsh/zprof
fi

# echo -ne '\e[5 q'
# cat ~/.local/state/caelestia/sequences.txt

zsource() {
  local file=$1
  local zwc="${file}.zwc"
  if [[ -f "$file" && (! -f "$zwc" || "$file" -nt "$file") ]]; then
    zcompile "$file"
  fi
  source "$file"
}

# ── 1. Environment Variables (Early) ────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
export NVM_DIR="$HOME/.nvm"
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=vivaldi-stable
export XDG_CURRENT_DESKTOP=KDE
export GTK_USE_PORTAL=1
export CPATH=$CPATH:/usr/local/include
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export SUDO_ASKPASS='/usr/bin/ksshaskpass'
# Suppress only OpenSSL legacy provider warnings
export PYTHONWARNINGS="ignore::Warning:importlib._bootstrap"
export ZSH=$(readlink -f $HOME/.config/zsh)
# export DRIFT_TIMEOUT=300
# ── 2. Path Setup ───────────────────────────────────────────────────
typeset -U path PATH  # Keep unique entries only
path=(
  $PYENV_ROOT/bin
  /home/linuxbrew/.linuxbrew/bin
  $HOME/.spicetify
  $HOME/.luarocks/bin
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
  $PNPM_HOME
  $HOME/go/bin
  $HOME/.local/bin
  $HOME/.cargo/bin
  $path
)
export PATH

# ── 3. Zinit (Plugin Manager) ───────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p ${ZINIT_HOME:h}
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
fi
zsource $ZINIT_HOME/zinit.zsh

# ── 4. Theme ────────────────────────────────────────────────────────
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && zsource ~/.p10k.zsh

# ── 5. History Settings ─────────────────────────────────────────────
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
       hist_save_no_dups hist_find_no_dups

# ── 6. Completion System ────────────────────────────────────────────
# autoload -Uz compinit
# # Smart compinit: only regenerate once per day
# if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
#   compinit
# else
#   compinit -C
# fi
autoload -Uz compinit
ZSH_COMPDUMP="${ZSH}/.zcompdump"
compinit -C -d "$ZSH_COMPDUMP"
autoload -U +X bashcompinit && bashcompinit
alias zcomp-rebuild='rm -f "$ZSH_COMPDUMP" && compinit && echo "Zsh autocomplete cache rebuilt!"'
zstyle :compinstall filename '/home/tony/.config/zsh/.zshrc'

# Completion styling
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' 
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# ── 7. Core Plugins (Optimized Loading) ─────────────────────────────

# FZF initialization
if command -v fzf >/dev/null; then
  if [[ -f ~/.fzf.zsh ]]; then
    zsource ~/.fzf.zsh
  else
    eval "$(fzf --zsh)"
  fi
fi

# FZF-Tab (Must load after compinit, but BEFORE plugins that wrap ZLE)
zinit ice depth=1 wait lucid
zinit light Aloxaf/fzf-tab

# Load autosuggestions (AFTER fzf-tab, BEFORE syntax-highlighting)
zinit wait lucid light-mode for \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# Syntax highlighting LAST (after all widgets are created)
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# ── 8. Lazy Tool Loading ────────────────────────────────────────────

# Pyenv lazy load
if [[ -d $PYENV_ROOT/bin ]]; then
  function pyenv() {
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    unfunction pyenv
    pyenv "$@"
  }
fi

if [[ -d "$NVM_DIR" ]]; then
  # Create a shared loader function to avoid repetition
  _load_nvm() {
    unset -f nvm node npm npx gemini geminicommit codex
    
    # Load NVM
    [[ -s "$NVM_DIR/nvm.sh" ]] && zsource "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && zsource "$NVM_DIR/bash_completion"
    
    # Now that NVM is loaded, add the bin path once
    export PATH="$NVM_DIR/versions/node/$(ls -t $NVM_DIR/versions/node 2>/dev/null | head -1)/bin:$PATH"
  }

  # Define the placeholders
  nvm() { _load_nvm; nvm "$@" }
  node() { _load_nvm; node "$@" }
  npm() { _load_nvm; npm "$@" }
  npx() { _load_nvm; npx "$@" }
  gemini() { _load_nvm; gemini "$@" }
  geminicommit() { _load_nvm; geminicommit "$@" }
  codex() { _load_nvm; codex "$@" }

fi

# Homebrew lazy load
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  function brew() {
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    unfunction brew
    brew "$@"
  }
fi

# # Vivado lazy load
# if [[ -f /tools/Xilinx/Vivado/2024.2/settings64.sh ]]; then
#   function vivado() {
#     source /tools/Xilinx/Vivado/2024.2/settings64.sh
#     unfunction vivado
#     vivado "$@"
#   }
# fi

# Zoxide deferred init
zinit ice wait lucid atload'
  command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
'
zinit light zdharma-continuum/null

# ── 9. Keybindings ──────────────────────────────────────────────────
bindkey '^P' fzf-history-widget
bindkey '^N' fzf-history-widget
bindkey '^[ ' autosuggest-accept

# ── 10. Extra Environment Loaders (Deferred) ────────────────────────
zinit ice wait"1" lucid atload'
  [[ -r "$HOME/.opam/opam-init/init.zsh" ]] && zsource "$HOME/.opam/opam-init/init.zsh" >/dev/null 2>&1
'
zinit light zdharma-continuum/null

zinit ice wait"1" lucid atload'
  [[ -f ~/.config/nvim-Lazyman/.lazymanrc ]] && zsource ~/.config/nvim-Lazyman/.lazymanrc
  [[ -f ~/.config/nvim-Lazyman/.nvimsbind ]] && zsource ~/.config/nvim-Lazyman/.nvimsbind
'
zinit light zdharma-continuum/null

# Modules (only if exists)
[[ -f /etc/profile.d/modules.sh ]] && zsource /etc/profile.d/modules.sh

# ── 11. Aliases ─────────────────────────────────────────────────────
# Directory Listings
alias ls='eza -a --color=always --group-directories-first --icons --hyperlink'
alias la='eza -a --color=always --group-directories-first --icons --hyperlink'
alias ll='eza -l --color=always --group-directories-first --icons --hyperlink'
alias lt='eza -aT --color=always --group-directories-first --icons --hyperlink'
alias l.='eza -ald --color=always --group-directories-first --icons --hyperlink .*'

# Navigation & File Ops
alias cd..='cd ..'
alias pdw='pwd'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias df='df -h'
alias rm='trash-put'
alias vim='nvim'
alias cat='bat --style header --style snip --style changes --style header'
alias ff=fastfetch
alias open_erp='conda run -n mtp --live-stream python ~/iitkgp-erp-login-pypi/examples/open_erp.py'

# System Updates (Garuda-specific)
alias _sysup='echo -e "\n\033[1;38;2;184;187;38mSTARTING GARUDA UPDATE\033[0m\n"; garuda-update; echo -e "\n\033[1;38;2;184;187;38mSTARTING AUR UPDATE\033[0m\n"; paru -Sua; echo -e "\n\033[1;38;2;184;187;38mUPDATING tldr cache\033[0m\n"; tldr --update'

for t in update udpate upate updte updqte; do alias $t=_sysup; done

alias upqll='paru -Syu --noconfirm'
alias upal='paru -Syu --noconfirm'
alias gu='garuda-update'

# SSH Shortcuts
# alias pshaktihome="ssh -p 4422 21ec37031@paramshakti.iitkgp.ac.in"
# alias pshaktikgp="ssh 21ec37031@paramshakti.iitkgp.ac.in"

# Misc
alias gmc=geminicommit
alias ts=typestorm
alias pacinstall="sudo pacman -S"
alias clearcache="sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches"
alias btop="btop --force-utf"
alias viu=viu-media

#pacman
alias sps='sudo pacman -S'
alias spr='sudo pacman -R'
alias sprs='sudo pacman -Rs'
alias sprdd='sudo pacman -Rdd'
alias spqo='sudo pacman -Qo'
alias spsii='sudo pacman -Sii'
alias pss='pacman -Ss'

alias limitpower='sudo ryzenadj --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000; supergfxctl --mode Integrated'
alias dgpu='supergfxctl --mode Hybrid'
alias log_out='qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout'
# alias log_out ='hyprctl dispatch exit'
alias icat="kitten icat"
alias d="kitten diff"
alias update=gu-notify.exp
alias zshrc="vim ~/.config/zsh/.zshrc"
alias sgc=supergfxctl
alias wall="sudo ryzenadj --stapm-limit=80000 --fast-limit=80000 --slow-limit=80000 --tctl-temp=96"
alias battery="sudo ryzenadj --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000"
# alias paru="~/.local/bin/paru-notify.exp"
alias makex="chmod +x"
alias lsg="ls | grep"
alias gmni=gemini
alias oc=opencode
alias se=sudoedit
alias webcam="mpv av://v4l2:/dev/video0"


# ── 12. Functions ───────────────────────────────────────────────────
# Archive Extractor
ex() {
  local f=$1
  [[ -f $f ]] || { print "'$f' is not a valid file"; return 1; }
  case $f in
    *.tar.bz2)  tar xjf $f ;;
    *.tar.gz)   tar xzf $f ;;
    *.bz2)      bunzip2 $f ;;
    *.rar)      unrar x $f ;;
    *.gz)       gunzip $f ;;
    *.tar)      tar xf $f ;;
    *.tbz2)     tar xjf $f ;;
    *.tgz)      tar xzf $f ;;
    *.zip)      unzip $f ;;
    *.Z)        uncompress $f ;;
    *.7z)       7z x $f ;;
    *.deb)      ar x $f ;;
    *.tar.xz)   tar xf $f ;;
    *.tar.zst)  tar xf $f ;;
    *)          print "'$f' cannot be extracted via ex()";;
  esac
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/usr/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/usr/etc/profile.d/conda.sh" ]; then
#         . "/usr/etc/profile.d/conda.sh"
#     else
#         export PATH="/usr/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# Lazy load Conda for MTP work
conda() {
  unfunction conda
  # The original conda init logic goes here
  __conda_setup="$('/usr/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  eval "$__conda_setup"
  unset __conda_setup
  conda "$@"
}

unset KDE_FULL_SESSION
unset KDE_SESSION_VERSION
export XDG_CURRENT_DESKTOP=Hyprland
export LESSCHARSET="utf-8"

zinit ice wait'0' lucid atload'eval "$(atuin init zsh --disable-up-arrow)"'
zinit light zdharma-continuum/null

# zinit ice wait'0' lucid atload'eval "$(drift shell-init zsh)"'
# zinit light zdharma-continuum/null

# source /usr/bin/virtualenvwrapper.sh

if [ $PROFILING_MODE -ne 0 ]; then
    zprof
fi
