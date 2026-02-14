{ config, pkgs, ... }:

{
  # Session management via extension
  home.packages = [
    pkgs.gnomeExtensions.another-window-session-manager
  ];

  # GNOME settings
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Super>s" ];
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "another-window-session-manager@nicke.github.io"
      ];
    };

    # Auto-restore previous session at login
    "org/gnome/shell/extensions/another-window-session-manager" = {
      restore-previous-session-at-startup = true;
      auto-close-apps-and-windows-before-saving = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = 0;
    };
  };
}
