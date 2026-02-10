{ config, pkgs, ... }:

{
  # Hyprland keybind helper script
  home.packages = [
    (pkgs.writeShellScriptBin "hypr-help" ''
      rofi -dmenu -i -p "Hyprland Keybinds" -theme-str 'window {width: 50%;}' << 'HELP'
╔═══════════════════════════════════════════════════╗
║         HYPRLAND KEYBINDS CHEATSHEET             ║
╚═══════════════════════════════════════════════════╝

🚀 APPLICATIONS
  Super + Enter       → Open Terminal (Kitty)
  Super + B           → Firefox Browser
  Super + E           → File Manager (Nautilus)
  Super + D           → App Launcher (Rofi)

📸 SCREENSHOTS
  Super + S           → Screenshot (region to clipboard)
  Super + Shift + S   → Screenshot (region to file)

🪟 WINDOW MANAGEMENT
  Super + Q           → Close Window
  Super + F           → Fullscreen
  Super + V           → Toggle Floating
  Super + L           → Lock Screen

🧭 NAVIGATION
  Super + Arrow Keys  → Move Focus
  Super + 1-9         → Switch Workspace
  Super + Shift + 1-9 → Move Window to Workspace

📌 HELP
  Super + H           → Show This Help
  Super + Shift + Q   → Exit Hyprland (back to GDM)

💡 TIP: Click anywhere to close this menu
HELP
    '')
  ];

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Environment variables
      env = [
        "PATH,/run/current-system/sw/bin:/home/abdo/.nix-profile/bin:$PATH"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_CURRENT_DESKTOP,Hyprland"
      ];

      # Modifier key (Super/Windows key)
      "$mod" = "SUPER";

      # Monitors (auto-detect)
      monitor = ",preferred,auto,1";

      # Autostart
      exec-once = [
        "waybar"
        "dunst"
        "hyprpaper"
        "~/.config/hypr/scripts/restore-session.sh"
        "notify-send 'Hyprland Started' 'Press Super+H for keybind help' -t 5000"
      ];

      # Input configuration
      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      # General appearance
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(5bcefaee) rgba(f5a97fee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Decorations
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # === KEYBINDINGS ===

      bind = [
        # HELP
        "$mod, H, exec, hypr-help"

        # Applications
        "$mod, RETURN, exec, kitty"
        "$mod, B, exec, firefox"
        "$mod, E, exec, nautilus"
        "$mod, D, exec, rofi -show drun"

        # Screenshot
        "$mod, S, exec, grimblast copy area"
        "$mod SHIFT, S, exec, grimblast save area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send 'Screenshot saved'"

        # Window management
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, down"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Special workspace
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"

        # System
        "$mod, L, exec, swaylock"
        "$mod SHIFT, Q, exit"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window rules
      windowrulev2 = [
        "float, class:(pavucontrol)"
        "float, title:(Picture-in-Picture)"
        "pin, title:(Picture-in-Picture)"
        "float, class:(rofi)"
      ];
    };
  };

  # Hyprpaper (wallpaper) config - FIXED
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = "/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jxl";
      wallpaper = ",/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jxl";
    };
  };

  # Session restoration for Hyprland (stored locally, not in git)
  home.file.".config/hypr/scripts/save-session.sh" = {
    text = ''
      #!/usr/bin/env bash
      SESSION_FILE="$HOME/.cache/hyprland-session.txt"
      mkdir -p "$(dirname "$SESSION_FILE")"
      hyprctl clients -j | jq -r '.[] | "\(.class)|\(.workspace.id)"' > "$SESSION_FILE"
    '';
    executable = true;
  };

  home.file.".config/hypr/scripts/restore-session.sh" = {
    text = ''
      #!/usr/bin/env bash
      SESSION_FILE="$HOME/.cache/hyprland-session.txt"
      if [ -f "$SESSION_FILE" ]; then
        while IFS='|' read -r class workspace; do
          case "$class" in
            kitty|Alacritty)
              hyprctl dispatch workspace "$workspace" && kitty &
              ;;
            firefox)
              hyprctl dispatch workspace "$workspace" && firefox &
              ;;
            org.gnome.Nautilus)
              hyprctl dispatch workspace "$workspace" && nautilus &
              ;;
            Spotify)
              hyprctl dispatch workspace "$workspace" && spotify &
              ;;
          esac
          sleep 0.5
        done < "$SESSION_FILE"
      fi
    '';
    executable = true;
  };
}
