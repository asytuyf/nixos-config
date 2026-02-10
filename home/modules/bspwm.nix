{ config, pkgs, ... }:

{
  # Session management commands (same as other DEs)
  home.packages = [
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

  # Save session on logout
  systemd.user.services.bspwm-save-session-on-logout = {
    Unit = {
      Description = "Save session on logout";
      DefaultDependencies = false;
      Before = [ "shutdown.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "save-if-bspwm" ''
        ${pkgs.procps}/bin/pgrep -x bspwm > /dev/null && save-session || true
      ''}";
      RemainAfterExit = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
