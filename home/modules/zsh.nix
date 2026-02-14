{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      mycmds = "cat /etc/nixos/my_cheatsheet.txt";
      dwell = "cargo run --manifest-path ${config.home.homeDirectory}/personel_projects/dotwell/Cargo.toml --";
      reveal = "tree -L 2 -C";  # Show directory structure with colors, 2 levels deep
    };
    
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    initContent = ''
      setopt INTERACTIVE_COMMENTS
      PROMPT='%F{yellow}[%n@NixOS:%F{blue}%~%F{yellow}]$%f '

      # === CUSTOM SHELL FUNCTIONS ===

      # nsync: Build NixOS config and push to GitHub
      nsync() {
        local msg=$1
        if [ -z "$msg" ]; then
          msg="Automated sync: $(date +'%Y-%m-%d %H:%M')"
        fi

        cd /etc/nixos
        echo "📂 Staging changes..."
        sudo git add .

        echo "🏗️  Building system..."
        if sudo -E nixos-rebuild switch --flake .#nixos; then
          if sudo git diff --cached --quiet; then
            echo "🟡 No changes to commit."
            return 0
          fi

          echo "✅ Build successful! Saving to GitHub..."
          sudo git commit -m "$msg"
          sudo -E git pull --rebase origin main
          sudo -E git push origin main
          echo "🚀 System updated and synced to Cloud."
        else
          echo "❌ Build FAILED. Check errors."
          return 1
        fi
      }

      nupdate() {
        sudo nix flake update /etc/nixos && sudo -E nixos-rebuild switch --flake /etc/nixos#nixos
      }

      nupdate-sync() {
        sudo nix flake update /etc/nixos && nsync "$@"
      }

      nstat() {
        local repo="/etc/nixos"
        echo "== /etc/nixos git status =="
        git -C "$repo" status -sb

        echo "== flake.lock input revs =="
        python - <<'PY2'
import json, subprocess
from pathlib import Path
repo = '/etc/nixos'

def load(text):
    return json.loads(text)

def revs(data):
    out = {}
    for k, v in data.get('nodes', {}).items():
        locked = v.get('locked', {})
        if 'rev' in locked:
            out[k] = locked['rev'][:7]
    return out

wt = load(Path(f"{repo}/flake.lock").read_text())
wt_revs = revs(wt)
try:
    head_text = subprocess.check_output(["git", "-C", repo, "show", "HEAD:flake.lock"], text=True)
    head_revs = revs(load(head_text))
    changed = []
    for k in sorted(set(wt_revs) | set(head_revs)):
        if wt_revs.get(k) != head_revs.get(k):
            changed.append((k, head_revs.get(k, '-'), wt_revs.get(k, '-')))
    if changed:
        for k, old, new in changed:
            if k in {"nixpkgs", "home-manager", "sops-nix"}:
                print(f"{k}: {old} -> {new}")
        if not any(k in {"nixpkgs", "home-manager", "sops-nix"} for k, _, _ in changed):
            print("flake.lock changed (no core inputs changed)")
    else:
        print("flake.lock: no rev changes from HEAD")
except subprocess.CalledProcessError:
    print("flake.lock: no HEAD to compare")
PY2

        echo "== current system =="
        readlink -f /run/current-system
      }

      nclean() {
        echo "🧹 Garbage collecting old generations..."
        sudo nix-collect-garbage --delete-older-than 10d
        echo "🧽 Optimizing store..."
        sudo nix store optimise
      }

      # addcmd: Add command to personal vault
      addcmd() {
        local REPO_PATH="$HOME/personel_projects/directory_website"
        local JSON_FILE="$REPO_PATH/public/snippets.json"
        
        (cd "$REPO_PATH" && git pull origin main --rebase > /dev/null 2>&1)

        echo -n "📁 CATEGORY: "
        read cat_name
        echo -n "📝 DESCRIPTION: "
        read desc

        local cmd_to_save="$*"
        if [ -z "$cmd_to_save" ]; then
            echo "Error: You must provide a command to save."
            return 1
        fi

        jq --arg cmd "$cmd_to_save" --arg cat "$cat_name" --arg desc "$desc" \
           '. += [{"cmd": $cmd, "cat": $cat, "desc": $desc, "date": "'$(date +'%Y-%m-%d')'"}]' \
           "$JSON_FILE" > /tmp/temp.json && mv /tmp/temp.json "$JSON_FILE"

        echo "[$cat_name] $cmd_to_save # $desc" >> /etc/nixos/my_cheatsheet.txt
        
        echo "✅ Saved locally. Run 'vault-sync' to go live."
      }

      # vault-sync: Push updates to vault website
      vault-sync() {
        local msg=$1
        if [ -z "$msg" ]; then msg="Vault Update: $(date +'%Y-%m-%d %H:%M')"; fi

        local REPO_PATH="$HOME/personel_projects/directory_website"
        cd "$REPO_PATH"
        
        if git diff --quiet && git diff --cached --quiet; then
          echo "📥 Syncing web deletions..."
          git pull origin main --rebase
        else
          echo "🟡 Skipping pull: working tree not clean."
        fi

        echo "📤 Pushing new manifest..."
        git add .
        if git diff --cached --quiet; then
          echo "🟡 No changes to push."
        else
          git commit -m "$msg"
          git push origin main
        fi
        
        vercel --prod
        echo "🚀 Genesis Vault live."
        cd - > /dev/null
      }

      # addgoal: Add a goal to your project tracker
      addgoal() {
        local REPO_PATH="$HOME/personel_projects/directory_website"
        local JSON_FILE="$REPO_PATH/public/goals.json"

        if [ ! -f "$JSON_FILE" ]; then echo "[]" > "$JSON_FILE"; fi

        echo -n "🎯 PROJECT (e.g. Website, NixOS, Life): "
        read project
        echo -n "🔥 PRIORITY (High/Med/Low): "
        read priority
        
        local task="$*"
        if [ -z "$task" ]; then
            echo -n "📝 MISSION DETAILS: "
            read task
        fi

        jq ". += [{\"id\": \"$(date +%s)\", \"project\": \"$project\", \"task\": \"$task\", \"priority\": \"$priority\", \"status\": \"PENDING\", \"date\": \"$(date +'%Y-%m-%d')\"}]" "$JSON_FILE" > /tmp/goals.json && mv /tmp/goals.json "$JSON_FILE"

        echo "✅ Mission added to log. Run 'vault-sync' to deploy."
      }

      # editgoals: Edit goals manually
      editgoals() {
        micro ~/personel_projects/directory_website/public/goals.json
      }

      # Create cheatsheet file if it doesn't exist
      if [ ! -f /etc/nixos/my_cheatsheet.txt ]; then
        touch /etc/nixos/my_cheatsheet.txt
      fi
    '';
  };
}
