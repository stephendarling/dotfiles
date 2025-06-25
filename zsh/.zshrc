if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

find ~/.personal/ -type f -print0 | while IFS= read -r -d $'\0' personal_file; do
  source "$personal_file"
done

# brew
export PATH="/opt/homebrew/bin:$PATH"
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

export PATH="$PATH:$HOME/.config/bin"
export PATH="$PATH:$HOME/go/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# aliases
alias gs="git status"
alias ga="git add -A"
alias gcm="git commit -m"
alias hist='history | awk '\''{ $1=""; sub(/^[ \t]+/, ""); print }'\'' | tail -r | awk '\''!seen[$0]++'\'' | fzf --height 40% --layout=reverse --border --prompt="History > " --bind '\''enter:execute-silent(echo -n {} | pbcopy)+abort'\'''
alias tg="terramate generate"
alias tr="terramate run"
alias lg="lazygit"
alias awsw='aws sts get-caller-identity'

# zoxide
eval "$(zoxide init zsh)"
alias sr="sesh connect root"
