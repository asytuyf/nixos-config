{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you
  home.username = "abdo";
  home.homeDirectory = "/home/abdo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # --- YOUR SETTINGS ---
  programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Asytuyf";
          email = "nabaoui21@gmail.com";
        };
      };
    };

  # 1. The Screenshot Shortcut
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Super>s" ];
    };
  };

  home.sessionPath = [ "$HOME/.cargo/bin" ];

  # --- ZSH CONFIGURATION ---
 programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      mycmds = "cat /etc/nixos/my_cheatsheet.txt";
    };
    
    history = {
      size = 10000;
      path = "/home/abdo/.zsh_history";
    };

    # We use initContent to stop the deprecation warning
    initContent = ''
      setopt INTERACTIVE_COMMENTS
      PROMPT='%F{yellow}[%n@NixOS:%F{blue}%~%F{yellow}]$%f '

      nsync() {
        local msg=$1
        if [ -z "$msg" ]; then
          msg="Automated sync: $(date +'%Y-%m-%d %H:%M')"
        fi

        cd /etc/nixos
        echo "📂 Staging changes..."
        sudo git add .

        echo "🏗️  Building system..."
        # We use -E here so the build can see your environment
        if sudo -E nixos-rebuild switch --flake .#nixos; then
          echo "✅ Build successful! Saving to GitHub..."
          sudo git commit -m "$msg"
          # THE FIX: Added -E to use your gh credentials
          sudo -E git push origin main
          echo "🚀 System updated and synced to Cloud."
        else
          echo "❌ Build FAILED. Check errors."
          return 1
        fi
      }

      # 1. ADD COMMAND (Fixed)
      addcmd() {
        local REPO_PATH="$HOME/personel_projects/directory_website"
        local JSON_FILE="$REPO_PATH/public/snippets.json"
        
        # Pull web deletions first to stay in sync
        (cd "$REPO_PATH" && git pull origin main --rebase > /dev/null 2>&1)

        echo -n "📁 CATEGORY: "
        read cat_name
        echo -n "📝 DESCRIPTION: "
        read desc

        # THE FIX: We capture the command itself from the arguments
        local cmd_to_save="$*"
        if [ -z "$cmd_to_save" ]; then
            echo "Error: You must provide a command to save."
            return 1
        fi

        # Save to JSON
        jq --arg cmd "$cmd_to_save" --arg cat "$cat_name" --arg desc "$desc" \
           '. += [{"cmd": $cmd, "cat": $cat, "desc": $desc, "date": "'$(date +'%Y-%m-%d')'"}]' \
           "$JSON_FILE" > /tmp/temp.json && mv /tmp/temp.json "$JSON_FILE"

        # Save to text file
        echo "[$cat_name] $cmd_to_save # $desc" >> /etc/nixos/my_cheatsheet.txt
        
        echo "✅ Saved locally. Run 'vault-sync' to go live."
      }

      # 2. VAULT SYNC (Smart Push)
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

      # 3. ADD GOAL (JSON Version)
      addgoal() {
        local REPO_PATH="$HOME/personel_projects/directory_website"
        local JSON_FILE="$REPO_PATH/public/goals.json"

        # Auto-create if missing
        if [ ! -f "$JSON_FILE" ]; then echo "[]" > "$JSON_FILE"; fi

        echo -n "🎯 PROJECT (e.g. Website, NixOS, Life): "
        read project
        echo -n "🔥 PRIORITY (High/Med/Low): "
        read priority
        
        # Description is the argument you pass: addgoal "Fix the bugs"
        local task="$*"
        if [ -z "$task" ]; then
            echo -n "📝 MISSION DETAILS: "
            read task
        fi

        # Use /tmp to avoid permission errors
        jq ". += [{\"id\": \"$(date +%s)\", \"project\": \"$project\", \"task\": \"$task\", \"priority\": \"$priority\", \"status\": \"PENDING\", \"date\": \"$(date +'%Y-%m-%d')\"}]" "$JSON_FILE" > /tmp/goals.json && mv /tmp/goals.json "$JSON_FILE"

        echo "✅ Mission added to log. Run 'vault-sync' to deploy."
      }

      # 4. EDIT GOALS (Manual JSON Edit)
      editgoals() {
        # Opens the file in micro/vim so you can delete lines or change "PENDING" to "DONE"
        micro ~/personel_projects/directory_website/public/goals.json
      }

      if [ ! -f /etc/nixos/my_cheatsheet.txt ]; then
        touch /etc/nixos/my_cheatsheet.txt
      fi
    '';
  };

  programs.home-manager.enable = true;
}