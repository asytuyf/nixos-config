{ config, pkgs, ... }:

{
  # General system packages
  environment.systemPackages = with pkgs; [
    # Terminal utilities
    wget
    curl
    htop
    btop          # Better htop with GPU/network/disk monitoring
    fastfetch
    bat
    jq
    unzip
    ranger
    fortune
    tree          # Directory visualization
    python3       # Python for scripts

    # Terminal emulator
    kitty

    # Entertainment
    spotify
    steam
    hydralauncher
    spicetify-cli

    # System utilities
    gparted
    home-manager
  ];

  # Enable Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
