{ config, pkgs, ... }:

{
  # Hyprland packages (help script + session management)
  home.packages = [
    # Keybind helper
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

    # Save session - just save which apps are open
    (pkgs.writeShellScriptBin "save-session" ''
      SESSION_FILE="$HOME/.cache/de-session.json"
      mkdir -p "$(dirname "$SESSION_FILE")"

      if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
        ${pkgs.hyprland}/bin/hyprctl clients -j | ${pkgs.jq}/bin/jq '[.[] | .class]' > "$SESSION_FILE"
      elif ${pkgs.procps}/bin/pgrep -x gnome-shell > /dev/null; then
        if command -v wmctrl &> /dev/null; then
          wmctrl -lx | awk '{print $3}' | cut -d'.' -f2 | ${pkgs.jq}/bin/jq -R . | ${pkgs.jq}/bin/jq -s . > "$SESSION_FILE"
        fi
      elif ${pkgs.procps}/bin/pgrep -x bspwm > /dev/null; then
        ${pkgs.bspwm}/bin/bspc query -N -n .window | while read -r wid; do
          ${pkgs.xorg.xprop}/bin/xprop -id "$wid" WM_CLASS 2>/dev/null | grep -Po '"\K[^"]+(?=")' | tail -1
        done | ${pkgs.jq}/bin/jq -R . | ${pkgs.jq}/bin/jq -s . > "$SESSION_FILE"
      fi
    '')

    # Restore session - just launch the apps that were open
    (pkgs.writeShellScriptBin "restore-session" ''
      SESSION_FILE="$HOME/.cache/de-session.json"
      [ ! -f "$SESSION_FILE" ] && exit 0

      ${pkgs.jq}/bin/jq -r '.[]' "$SESSION_FILE" | while read -r app; do
        case "$app" in
          firefox|Firefox) ${pkgs.firefox}/bin/firefox & ;;
          kitty|Kitty) ${pkgs.kitty}/bin/kitty & ;;
          Alacritty|alacritty) ${pkgs.alacritty}/bin/alacritty & ;;
          org.gnome.Nautilus|nautilus|Nautilus) ${pkgs.nautilus}/bin/nautilus & ;;
          code|Code) code & ;;
        esac
        sleep 0.3
      done
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

      # Modifier key
      "$mod" = "SUPER";

      # Monitors
      monitor = ",preferred,auto,1";

      # Autostart
      exec-once = [
        "waybar"
        "dunst"
        "hyprpaper"
        "restore-session"
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

      # Keybindings
      bind = [
        "$mod, H, exec, hypr-help"
        "$mod, RETURN, exec, kitty"
        "$mod, B, exec, firefox"
        "$mod, E, exec, nautilus"
        "$mod, D, exec, rofi -show drun"
        "$mod, S, exec, grimblast copy area"
        "$mod SHIFT, S, exec, grimblast save area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send 'Screenshot saved'"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, down"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"
        "$mod, L, exec, swaylock"
        "$mod SHIFT, Q, exec, save-session && exit"
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

  # Hyprpaper (wallpaper)
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = "/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jxl";
      wallpaper = ",/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jxl";
    };
  };
}
