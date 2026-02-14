{ config, pkgs, lib, ... }:

{
  # General system packages
  environment.systemPackages = with pkgs; [
    # Terminal utilities (work everywhere)
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

    # Music (Spotify works on ARM)
    spotify

    # System utilities
    gparted
    home-manager
  ]
  # x86-only packages (Steam, game launchers)
  ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    steam
    hydralauncher
    spicetify-cli
  ];

  # Enable Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
