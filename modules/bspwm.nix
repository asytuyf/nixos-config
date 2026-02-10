# BSPWM Window Manager Configuration
# Based on gh0stzk dotfiles requirements
# Can be used alongside GNOME - switch at login

{ config, pkgs, ... }:

{
  # Enable bspwm window manager (keeps other DEs/WMs intact)
  services.xserver.windowManager.bspwm.enable = true;

  # Enable MPD service (Music Player Daemon)
  services.mpd = {
    enable = true;
    user = "abdo";
    musicDirectory = "/home/abdo/Music";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "PulseAudio"
      }
    '';
  };

  # System-wide packages needed for bspwm setup
  environment.systemPackages = with pkgs; [
    # Core window manager components
    bspwm
    sxhkd
    polybar
    picom
    dunst
    rofi
    jgmenu

    # Terminal emulators
    alacritty
    kitty

    # File managers and utilities
    xfce.thunar
    xfce.tumbler
    gvfs
    pcmanfm
    ranger
    yazi

    # Media and music
    mpd
    mpc-cli
    ncmpcpp
    mpv
    playerctl
    pamixer

    # Image and screenshot tools
    feh
    maim
    imagemagick
    xcolor

    # System utilities
    brightnessctl
    redshift
    lxsession
    xdotool
    xdo
    xclip
    xdg-user-dirs

    # Rofi utilities
    networkmanagerapplet
    bluez
    blueman

    # Development tools
    geany

    # Shell utilities
    bat
    eza
    fzf
    jq

    # Fonts (critical for themes)
    inconsolata
    jetbrains-mono
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "Terminus" "UbuntuMono" ]; })

    # Icon themes
    papirus-icon-theme

    # Clipboard manager
    clipcat

    # Python for scripts
    python3
    python3Packages.pygobject3

    # Node.js for eww and other tools
    nodejs

    # Rust toolchain (needed for some tools)
    rustup

    # Additional utilities from gh0stzk setup
    libwebp
    webp-pixbuf-loader

    # Xorg utilities
    xorg.xdpyinfo
    xorg.xkill
    xorg.xprop
    xorg.xrandr
    xorg.xsetroot
    xorg.xwininfo
    xorg.xrdb
  ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
