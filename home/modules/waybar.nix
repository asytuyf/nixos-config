{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/help" "pulseaudio" "network" "battery" "tray" ];
        
        # Workspaces
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "";
            default = "";
          };
        };
        
        # Active window title
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };
        
        # Clock
        clock = {
          interval = 60;
          format = "{:%H:%M - %a %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        # HELP BUTTON - Click for keybinds!
        "custom/help" = {
          format = "❓";
          tooltip = "Click for keybind help (or press Super+H)";
          on-click = "hypr-help";
        };
        
        # Audio
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "🔇";
          format-icons = {
            default = [ "🔈" "🔉" "🔊" ];
          };
          on-click = "pavucontrol";
        };
        
        # Network
        network = {
          format-wifi = "📶 {essid}";
          format-ethernet = "🔌 {ipaddr}";
          format-disconnected = "❌";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };
        
        # Battery
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "⚡ {capacity}%";
          format-icons = [ "🔋" "🔋" "🔋" "🔋" "🔋" ];
        };
        
        # System tray
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }
      
      window#waybar {
        background-color: rgba(26, 27, 38, 0.9);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
      }
      
      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background-color: transparent;
        border-bottom: 3px solid transparent;
      }
      
      #workspaces button.active {
        background-color: rgba(91, 206, 250, 0.2);
        border-bottom: 3px solid #5bcefa;
      }
      
      #workspaces button:hover {
        background-color: rgba(91, 206, 250, 0.1);
      }
      
      #window {
        padding: 0 10px;
        color: #89b4fa;
      }
      
      #clock {
        padding: 0 15px;
        color: #f5a97f;
        font-weight: bold;
      }
      
      #custom-help {
        padding: 0 10px;
        background-color: rgba(245, 169, 127, 0.2);
        color: #f5a97f;
        border-radius: 8px;
        margin: 4px;
        font-size: 16px;
      }
      
      #custom-help:hover {
        background-color: rgba(245, 169, 127, 0.4);
        cursor: pointer;
      }
      
      #pulseaudio,
      #network,
      #battery,
      #tray {
        padding: 0 10px;
        margin: 0 2px;
      }
      
      #battery.charging {
        color: #a6e3a1;
      }
      
      #battery.warning:not(.charging) {
        color: #f9e2af;
      }
      
      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation: blink 0.5s linear infinite alternate;
      }
      
      @keyframes blink {
        to {
          color: #1e1e2e;
        }
      }
    '';
  };
}
