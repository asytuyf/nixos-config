{ config, pkgs, ... }:

{
  # Hyprland - Modern Wayland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # For X11 apps (Discord, Steam, etc.)
  };

  # Essential Hyprland packages
  environment.systemPackages = with pkgs; [
    # Screenshot tools
    grim          # Screenshot tool
    slurp         # Region selector
    grimblast     # Convenient screenshot wrapper
    
    # Clipboard
    wl-clipboard  # Already added for GNOME, works here too
    
    # Notifications
    dunst         # Notification daemon
    libnotify     # notify-send command
    
    # App launcher
    rofi  # Application launcher
    
    # Wallpaper
    hyprpaper     # Wallpaper daemon for Hyprland
    
    # Screen locking
    swaylock      # Screen locker
    
    # System info / bar
    waybar        # Status bar
  ];

  # XDG portal for screen sharing, file pickers, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
