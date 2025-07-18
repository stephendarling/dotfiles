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
alias zad="ls -d */ | xargs -I {} zoxide add {}"

# git clone and zoxide add
clone() {
  local repo_url="$1"
  local repo_name

  if [ -z "$repo_url" ]; then
    echo "Usage: gc <repository_url>"
    return 1
  fi

  # 1. Perform the git clone
  echo "Cloning $repo_url..."
  git clone "$repo_url"

  # Check if git clone was successful
  if [ $? -ne 0 ]; then
    echo "Git clone failed. Aborting zoxide add."
    return 1
  fi

  # 2. Extract the repository name (basename of the URL without .git)
  repo_name=$(basename "$repo_url" .git)

  # 3. Add the cloned directory to zoxide
  if [ -d "$repo_name" ]; then
    echo "Adding '$repo_name' to zoxide..."
    zoxide add "$repo_name"
    echo "Successfully cloned and added to zoxide: $repo_name"
  else
    echo "Warning: Cloned directory '$repo_name' not found. Zoxide add skipped."
    echo "You might need to 'cd' into the cloned directory first if it was not created as expected."
  fi
}

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
