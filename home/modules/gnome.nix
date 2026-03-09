{ config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Super>s" ];
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "quicksettings-close-autofocus@gammelsami"
        "spotify-ad-block@danigm.net"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "screentospace@dilzhan.dev"
        "pomodoro@zhuravkovigor.dev"
        "panel-workspace-scroll@polymeilex.github.io"
        "music-scales@zenlinux.com"
        "focuscontrol@itsfernn"
        "focus@scaryrawr.github.io"
        "codecal@shihab.kopinfotech.com"
        "Picture-desktop-widget@GaszokS.github.com"
        "proton-checker@carvdev.github.com"
        "perfect-fit@ryliov.work.com"
        "overviewbackground@github.com.orbitcorrection"
        "clipqr@drien.com"
        "claude-code-usage@haletran.com"
        "weekly-commits@funinkina.is-a.dev"
        "splashindicator@ochi12.github.com"
        "pip-on-top@rafostar.github.com"
        "clipboard-indicator@tudmotu.com"
        "dash2dock-lite@icedman.github.com"
        "gnome-mosaic@jardon.github.com"
        "gTile@vibou"
        "paperwm@paperwm.github.com"
        "blur-my-shell@aunetx"
      ];
    };

    # Dark theme for GNOME and apps
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
    };

    # Screenshot settings
    "org/gnome/gnome-screenshot" = {
      auto-save-directory = "file:///home/abdo/Pictures/Screenshots";
      include-pointer = false;
      delay = 0;
    };

    # Disable screen timeout and sleep
    "org/gnome/desktop/session" = {
      idle-delay = 0;  # 0 = never go idle
    };

    # Disable screen blanking
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
      idle-activation-enabled = false;
    };

    # Power settings - never turn off screen
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
      idle-dim = false;
    };
  };

  # GTK dark theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  # Qt apps follow GTK dark theme
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
