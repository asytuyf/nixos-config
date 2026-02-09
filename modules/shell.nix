{ config, pkgs, ... }:

{
  # Zsh as default shell
  programs.zsh.enable = true;
  users.users.abdo.shell = pkgs.zsh;
}
