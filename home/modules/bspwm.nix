{ config, pkgs, ... }:

{
  # Enable bspwm session save systemd user service
  systemd.user.services.bspwm-save-session = {
    Unit = {
      Description = "Save bspwm session on logout";
      DefaultDependencies = false;
      Before = [ "shutdown.target" ];
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.config/bspwm/bin/save-session";
      RemainAfterExit = true;
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
