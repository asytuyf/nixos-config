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

      # 1. ADD COMMAND (Local Only)
      addcmd() {
        # Using 'personel_projects' as per your folder structure
        local REPO_PATH="$HOME/personel_projects/directory_website"
        local JSON_FILE="$REPO_PATH/public/snippets.json"

        # Check if file exists first
        if [ ! -f "$JSON_FILE" ]; then
          echo "[]" > "$JSON_FILE"
        fi

        echo -n "📁 CATEGORY (nix/git/react/ml): "
        read cat_name
        echo -n "📝 DESCRIPTION: "
        read desc

        # Structured JSON update
        jq ". += [{\"cmd\": \"$*\", \"cat\": \"$cat_name\", \"desc\": \"$desc\", \"date\": \"$(date +'%Y-%m-%d')\"}]" "$JSON_FILE" > temp.json && mv temp.json "$JSON_FILE"

        # Also save to your local text file for 'mycmds'
        echo "[$cat_name] $* # $desc" >> /etc/nixos/my_cheatsheet.txt
        
        echo "✅ Saved to local Vault. Run 'vault-sync' to go live."
      }

      # 2. VAULT SYNC (Commit and Deploy)
      vault-sync() {
        local REPO_PATH="$HOME/personel_projects/directory_website"
        cd "$REPO_PATH"
        
        git add public/snippets.json
        git commit -m "Vault Update: Syncing new archive entries"
        git push origin main
        
        # Deploy to Vercel
        vercel --prod
        
        echo "🚀 Genesis Vault synchronized and deployed."
        cd - > /dev/null
      }

      if [ ! -f /etc/nixos/my_cheatsheet.txt ]; then
        touch /etc/nixos/my_cheatsheet.txt
      fi
    '';
  };

  programs.home-manager.enable = true;
}