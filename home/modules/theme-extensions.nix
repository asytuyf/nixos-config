{ pkgs, lib, config, ... }:

let
  # ShaderPaper Extension Derivation (for Shader wallpapers)
  shaderpaper = pkgs.stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-shaderpaper";
    version = "unstable-2024-02-21";

    src = pkgs.fetchurl {
      url = "https://gitlab.com/raihan2000/shaderpaper/-/archive/08387d4a0a79856aa7c6d58703419675a90eb1e6/shaderpaper-08387d4a0a79856aa7c6d58703419675a90eb1e6.tar.gz";
      sha256 = "sha256-8snWCtWZ2kHTEhYXXTEwxtbNxPBQEAImCYH5KXHfbqY=";
    };

    nativeBuildInputs = [
      pkgs.glib
      pkgs.gettext
    ];

    buildInputs = [
      pkgs.gnome-shell
      pkgs.gnome-shell-extensions
    ];

    uuid = "shaderpaper@fogyverse.in";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions/${uuid}
      cp -r * $out/share/gnome-shell/extensions/${uuid}
      runHook postInstall
    '';

    postFixup = ''
      glib-compile-schemas $out/share/gnome-shell/extensions/${uuid}/schemas
    '';

    meta = with lib; {
      description = "Shader Wallpaper for GNOME";
      homepage = "https://gitlab.com/raihan2000/shaderpaper";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
    };
  };

in
{
  home.packages = with pkgs; [
    shaderpaper
    
    # Dependencies for Video/Animated Wallpapers (Hanabi, etc.)
    # Kept here so manual installation of such extensions works
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
        "shaderpaper@fogyverse.in"
      ];
    };
  };
  
  # Ensure the local directories exist for manual theme installation
  home.file.".themes/.keep".text = "";
  home.file.".icons/.keep".text = "";
  home.file.".local/share/fonts/.keep".text = "";
}
