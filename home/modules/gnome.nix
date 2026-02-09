{ config, pkgs, ... }:

{
  # GNOME keybindings and settings
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Super>s" ];
    };
  };
}
