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
        if sudo nixos-rebuild switch --flake .#nixos; then
          echo "✅ Build successful! Saving to GitHub..."
          sudo git commit -m "$msg" || true
          sudo git pull --rebase origin main && sudo git push origin main
          echo "🚀 System updated and synced to Cloud."
        else
          echo "❌ Build FAILED. Check errors."
          return 1
        fi
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
        
        echo "📥 Syncing web deletions..."
        git pull origin main --rebase

        echo "📤 Pushing new manifest..."
        git add .
        git commit -m "$msg"
        git push origin main
        
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
