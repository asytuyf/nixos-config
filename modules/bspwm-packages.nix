# All packages needed for gh0stzk bspwm dotfiles
{ config, pkgs, ... }:

{
  # Install all packages needed for the dotfiles
  environment.systemPackages = with pkgs; [
    # Core bspwm components
    sxhkd
    polybar
    picom
    dunst
    rofi
    jgmenu
    feh
    
    # Terminals
    alacritty
    kitty
    
    # File managers
    xfce.thunar
    xfce.tumbler
    pcmanfm
    ranger
    yazi
    
    # Media/Music
    mpd
    mpc
    ncmpcpp
    mpv
    playerctl
    pamixer
    
    # Screenshots and images
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
    
    # Shell tools
    bat
    eza
    fzf
    jq
    
    # Development
    git
    neovim
    geany
    nodejs
    
    # Network/Bluetooth
    networkmanagerapplet
    blueman
    
    # Clipboard
    clipcat
    
    # Fonts (Nerd Fonts for proper icon support)
    nerd-fonts.jetbrains-mono
    nerd-fonts.inconsolata
    
    # Icons
    papirus-icon-theme
    
    # Additional tools
    libwebp
    webp-pixbuf-loader
    rustup
    python3
    python3Packages.pygobject3
    
    # Xorg tools
    xorg.xdpyinfo
    xorg.xkill
    xorg.xprop
    xorg.xrandr
    xorg.xsetroot
    xorg.xwininfo
    xorg.xrdb
    xsettingsd
    
    # Lock screen
    i3lock-color
    
    # Eww widgets
    eww
  ];
  
  # Enable MPD service
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
}
