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
    
    # THIS is the feature you asked for:
    autosuggestion.enable = true;
    
    # Bonus: Makes commands green if they exist, red if they don't
    syntaxHighlighting.enable = true;

    # specific shell aliases (shortcuts)
    shellAliases = {
      ll = "ls -l";
      apply = "sudo nixos-rebuild switch";
      mycmds = "bat ~/.my_cheatsheet.txt || cat ~/.my_cheatsheet.txt";
    };
    
    # History settings
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      # A cleaner, more professional prompt
      PROMPT='%F{yellow}[%n@genesis-vault:%F{blue}%~%F{yellow}]$%f '

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
        echo "[$cat_name] $* # $desc" >> ~/.my_cheatsheet.txt
        
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

      if [ ! -f ~/.my_cheatsheet.txt ]; then
        touch ~/.my_cheatsheet.txt
      fi
    '';
  };

  programs.home-manager.enable = true;
}