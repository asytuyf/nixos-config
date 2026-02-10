{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix         # Git configuration
    ./modules/gnome.nix       # GNOME keybindings
    ./modules/bspwm.nix      # bspwm session management
    ./modules/hyprland.nix    # Hyprland configuration
    ./modules/waybar.nix      # Waybar status bar
    ./modules/zsh.nix         # Zsh with custom functions
    ./modules/shell-tools.nix # fzf and zoxide
  ];

  # Home Manager needs a bit of information about you
  home.username = "abdo";
  home.homeDirectory = "/home/abdo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
