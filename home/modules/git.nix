{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Asytuyf";
        email = "nabaoui21@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
