{ config, pkgs, ... }:

{
  # X11 and Desktop Environment
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.windowManager.bspwm.enable = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  console.keyMap = "fr";

  # GNOME utilities
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
  ];

  # Sound with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;
}
