# -----------------------------
# Base paths and editors
# -----------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export VIM="vim"
export PATH="$PATH:$(go env GOPATH)/bin"
export VIMRUNTIME=/usr/share/nvim/runtime
export CC=gcc

# -----------------------------
# Personal env files
# -----------------------------
PERSONAL="$XDG_CONFIG_HOME/zsh/personal"

if [[ -d "$PERSONAL" ]]; then
    for file in "$PERSONAL"/*; do
        [[ -r "$file" ]] && source "$file"
    done
fi

# -----------------------------
# FZF integration
# -----------------------------
for f in /usr/share/doc/fzf/examples/{key-bindings.zsh,completion.zsh}; do
    [[ -f "$f" ]] && source "$f"
done

# -----------------------------
# Work env vars
# -----------------------------
export NRDP="$HOME/work/nrdp"
export NRDP_BUILDS="$HOME/work/builds"
export PYTHONBREAKPOINT="pudb.set_trace"
export GOPATH="$HOME/go"
export DARWINS_DIR="$HOME/work/darwins"
export TVUI="$HOME/work/tvui"
export API_TOOLS="$HOME/work/tools/edge/scripts"
export GIT_EDITOR="$VIM"
export EOSIO_INSTALL_DIR="$HOME/personal/eos"
export NF_IDFILE="$HOME/.idfile"
export DENO_INSTALL="$HOME/.deno"
export N_PREFIX="$HOME/.local/n"
export DOTFILES="$HOME/.dotfiles"
export BOGART="$HOME/work/bogart"

# -----------------------------
# PATH additions
# -----------------------------
addToPathFront() {
    [[ -d "$1" ]] && PATH="$1:$PATH"
}

paths=(
    "$HOME/zig-linux-x86_64-0.16.0-dev.1484+d0ba6642b" #new zig
    "$HOME/.local/.npm-global/bin"
    "$HOME/.local/scripts"
    "$HOME/.local/bin"
    "$HOME/.local/n/bin"
    "$HOME/.local/go/bin"
    "$HOME/go/bin"
    "$HOME/personal/sumneko/bin"
    "$HOME/.deno/bin"
    "$HOME/.bun/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.turso"
)
for p in "${paths[@]}"; do addToPathFront "$p"; done
export PATH

# -----------------------------
# Keybinds
# -----------------------------
bindkey -s ^f "tmux-sessionizer\n"

# -----------------------------
# Functions
# -----------------------------
catr() { tail -n "+$1" "$3" | head -n "$(($2 - $1 + 1))"; }

validateYaml() {
    python - <<'EOF' "$1"
import yaml, sys
with open(sys.argv[1]) as f:
    yaml.safe_load(f)
EOF
}

goWork() { cp ~/.npm_work_rc ~/.npmrc; }
goPersonal() { cp ~/.npm_personal_rc ~/.npmrc; }

addThrottle() {
    local kbs="kbps"
    sudo tc qdisc add dev wlp59s0 handle 1: root htb default 11
    sudo tc class add dev wlp59s0 parent 1: classid 1:1 htb rate "$1$kbs"
    sudo tc class add dev wlp59s0 parent 1:1 classid 1:11 htb rate "$1$kbs"
}
removeThrottle() { sudo tc qdisc del dev wlp59s0 root; }

cat1Line() { tr -d '\n' < "$1"; }

ioloop() {
    local FIFO
    FIFO=$(mktemp -u /tmp/ioloop_$$_XXXXXX)
    trap "rm -f $FIFO" EXIT
    mkfifo "$FIFO"
    (: <"$FIFO" &) # prevent deadlock
    exec >"$FIFO" <"$FIFO"
}

eslintify() { npx eslint "$1"; }

# -----------------------------
# Oh-My-Zsh
# -----------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# -----------------------------
# Aliases
# -----------------------------
alias ll='ls -lah'
alias gs='git status'
alias luamake="$HOME/personal/lua-language-server/3rd/luamake/luamake"

# -----------------------------
# Bun
# -----------------------------
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# -----------------------------
# pnpm
# -----------------------------
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# -----------------------------
# Conda
# -----------------------------
__conda_setup="$('$HOME/.local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
elif [ -f "$HOME/.local/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/.local/anaconda3/etc/profile.d/conda.sh"
else
    export PATH="$HOME/.local/anaconda3/bin:$PATH"
fi
unset __conda_setup

# -----------------------------
# Final tweaks
# -----------------------------
export EDITOR="$VIM"
alias ls="exa -1 --icons"

