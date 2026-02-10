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
      # Modifier key (Super/Windows key)
      "$mod" = "SUPER";
      
      # Monitors (auto-detect)
      monitor = ",preferred,auto,1";
      
      # Autostart
      exec-once = [
        "waybar"                                        # Status bar
        "dunst"                                         # Notifications
        "hyprpaper"                                     # Wallpaper
        "notify-send '🎉 Hyprland Started' 'Press Super+H for keybind help' -t 5000"  # Welcome notification
      ];
      
      # Input configuration
      input = {
        kb_layout = "fr";           # French keyboard (matching your GNOME setup)
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
        "col.active_border" = "rgba(5bcefaee) rgba(f5a97fee) 45deg";  # Teal gradient
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
        # HELP - Show keybind cheatsheet
        "$mod, H, exec, hypr-help"
        
        # Applications
        "$mod, RETURN, exec, kitty"                    # Terminal
        "$mod, B, exec, firefox"                       # Browser
        "$mod, E, exec, nautilus"                      # File manager
        "$mod, D, exec, rofi -show drun"              # App launcher
        
        # Screenshot (matching your GNOME Super+S)
        "$mod, S, exec, grimblast copy area"          # Screenshot region to clipboard
        "$mod SHIFT, S, exec, grimblast save area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send 'Screenshot saved'"
        
        # Window management
        "$mod, Q, killactive"                          # Close window
        "$mod, F, fullscreen"                          # Fullscreen
        "$mod, V, togglefloating"                      # Toggle floating
        "$mod, P, pseudo"                              # Pseudo-tile
        "$mod, J, togglesplit"                         # Toggle split
        
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
        
        # Special workspace (scratchpad)
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"
        
        # System
        "$mod, L, exec, swaylock"                      # Lock screen
        "$mod SHIFT, Q, exit"                          # Exit Hyprland
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"   # Move window with mouse
        "$mod, mouse:273, resizewindow" # Resize window with mouse
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
  
  # Hyprpaper (wallpaper) config
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "/run/current-system/sw/share/backgrounds/gnome/geometrics-d.jxl"
      ];
      wallpaper = [
        ",/run/current-system/sw/share/backgrounds/gnome/geometrics-d.jxl"
      ];
    };
  };
}
