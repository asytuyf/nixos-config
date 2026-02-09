# Abdo's NixOS Configuration (Modular Structure)
# Main configuration file - imports all modules

{ config, pkgs, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix

    # Modular configuration
    ./modules/desktop.nix      # GNOME, display, sound, printing
    ./modules/development.nix  # Dev tools, languages, editors
    ./modules/packages.nix     # General packages, Firefox, unfree
    ./modules/shell.nix        # Zsh configuration
    ./modules/secrets.nix      # Secrets management (sops-nix)
  ];

  # Home Manager integration (configured in flake.nix)
  home-manager.users.abdo = import ./home/abdo.nix;

  # === CORE SYSTEM CONFIGURATION ===

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # User account
  users.users.abdo = {
    isNormalUser = true;
    description = "Abdo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # Automatic updating (ensure you nsync before reproducing!)
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # NixOS release version
  system.stateVersion = "25.11";
}
