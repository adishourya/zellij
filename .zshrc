# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export HELIX_RUNTIME=/Users/adi/code/helix/runtime

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="/Library/TeX/texbin:/Users/adi/.cargo/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="half-life"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='hx'
else
  export EDITOR='hx'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias vim="nvim"
alias vim="hx"
# bind alt-v to run vim .
bindkey -s '^[v' 'vim .\n'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/adi/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adi/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/adi/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adi/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


. "$HOME/.local/bin/env"


kitty-reload() {
    kill -SIGUSR1 $(pidof kitty)
}



# eval "$(starship init zsh)"

# Check if we are in a Zellij session
# if [[ -n "$ZELLIJ_SESSION_NAME" ]]; then
#   # This adds [session_name] to the start of your prompt
#   PROMPT="[%F{yellow}$ZELLIJ_SESSION_NAME%f] $PROMPT"
# fi

zellij_attach_fzf() {
  local session
  session=$(zellij ls | fzf --ansi | awk '{print $1}') || return

  [[ -z "$session" ]] && return

  # Leave ZLE completely
  zle -I

  # Queue command for normal shell execution
  BUFFER="zellij attach $session"
  zle accept-line
}

zle -N zellij_attach_fzf
bindkey '^[z' zellij_attach_fzf

# change directory with yazi press q where you want to leave
yy-widget() {
  emulate -L zsh

  # Leave ZLE cleanly
  zle -I

	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"

  rm -f -- "$tmp"

  # Redraw prompt in new directory
  zle reset-prompt
}

zle -N yy-widget
bindkey '^[-' yy-widget


# tab name as the directory its on
# if [[ -n "$ZELLIJ" ]]; then
#   _zellij_update_tabname() {
#     local current_dir="$PWD"
#     local tab_name

    
#     if [[ "$current_dir" == "$HOME" ]]; then
#       # use session name as default
#       # tab_name="/Users/adi/"
#       # tab_name="$ZELLIJ_SESSION_NAME"
#       tab_name="@home"
#     else
#       tab_name="${current_dir:t}"
#     fi

#     if command git rev-parse --is-inside-work-tree &>/dev/null; then
#       local git_root
#       git_root="$(git rev-parse --show-superproject-working-tree 2>/dev/null)"
#       [[ -z "$git_root" ]] && git_root="$(git rev-parse --show-toplevel)"

#       if [[ "${git_root:A:l}" != "${current_dir:A:l}" ]]; then
#         tab_name="${git_root:t}/${current_dir:t}"
#       fi
#     fi

#     # Truncate to 15 chars + "..."
#     local max=20
#     if (( ${#tab_name} > max )); then
#       tab_name="${tab_name[1,max]}..."
#     fi

#     nohup zellij action rename-tab "$tab_name" >/dev/null 2>&1 &!
#   }

#   autoload -Uz add-zsh-hook
#   add-zsh-hook chpwd _zellij_update_tabname

#   # run once on shell start
#   _zellij_update_tabname
# fi

# tab name as the program its running
if [[ -n "$ZELLIJ" ]]; then
  autoload -Uz add-zsh-hook

  _zellij_rename() {
    local name="$1"
    local max=20

    if (( ${#name} > max )); then
      name="${name[1,max]}..."
    fi

    nohup zellij action rename-tab "$name" >/dev/null 2>&1 &!
  }

  _zellij_path_name() {
    local current_dir="$PWD"
    local tab_name

    if [[ "$current_dir" == "$HOME" ]]; then
      tab_name="@home"
    else
      tab_name="${current_dir:t}"
    fi

    if command git rev-parse --is-inside-work-tree &>/dev/null; then
      local git_root
      git_root="$(git rev-parse --show-superproject-working-tree 2>/dev/null)"
      [[ -z "$git_root" ]] && git_root="$(git rev-parse --show-toplevel)"

      if [[ "${git_root:A:l}" != "${current_dir:A:l}" ]]; then
        tab_name="${git_root:t}/${current_dir:t}"
      fi
    fi

    _zellij_rename "$tab_name"
  }

  # Before command → program name
  _zellij_preexec() {
    local cmd="$1"
    local prog="${cmd%% *}"
    prog="${prog:t}"

    _zellij_rename "$prog"
  }

  # After command → path again
  _zellij_precmd() {
    _zellij_path_name
  }

  add-zsh-hook preexec _zellij_preexec
  add-zsh-hook precmd _zellij_precmd

  # Initial name
  _zellij_path_name
fi
