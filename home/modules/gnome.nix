{ config, pkgs, ... }:

{
  # GNOME keybindings and settings
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Super>s" ];
    };
    
    # Enable session restore - remember running applications
    "org/gnome/SessionManager" = {
      auto-save-session = true;
    };
    
    "org/gnome/desktop/session" = {
      idle-delay = 0;  # Don't auto-logout when idle
    };
  };
}
