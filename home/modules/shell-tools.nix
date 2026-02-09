{ config, pkgs, ... }:

{
  # fzf - Fuzzy finder (supercharges your terminal)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    
    # Keybindings:
    # Ctrl+R: Search command history
    # Ctrl+T: Search files in current directory
    # Alt+C: cd into subdirectory
  };

  # zoxide - Smarter cd (learns your most-used directories)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    
    # Usage:
    # z dirname  - Jump to directory (no full path needed!)
    # zi         - Interactive selection
  };
}
