{ config, pkgs, ... }:

{
  # General system packages
  environment.systemPackages = with pkgs; [
    # Terminal utilities
    wget
    curl
    htop
    btop
    fastfetch
    bat
    jq
    unzip
    ranger
    fortune
    tree
    python3

    # Terminal emulator
    kitty

    # Music
    spotify

    # System utilities
    gparted
    home-manager
    dysk

    # Gaming
    steam
    hydralauncher
    spicetify-cli
  ];

  # Enable Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
