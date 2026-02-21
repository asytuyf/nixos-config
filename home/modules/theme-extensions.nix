{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    # Dependencies for Video/Animated Wallpapers (e.g. for manual installation of extensions)
    clapper
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    
    # Dependencies for ShaderPaper and others
    pkgs.gnome-shell-extensions
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com" # Enable User Themes
      ];
    };
  };
  
  # Ensure the local directories exist for manual theme installation
  home.file.".themes/.keep".text = "";
  home.file.".icons/.keep".text = "";
  home.file.".local/share/fonts/.keep".text = "";
  home.file."Pictures/Wallpapers/Motion/.keep".text = "";
}
