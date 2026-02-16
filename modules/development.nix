{ config, pkgs, ... }:

{
  # Development tools and languages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    gh

    # Node.js ecosystem
    nodejs_24
    pnpm
    yarn
    nodePackages.vercel

    # Rust
    rustc
    cargo
    rust-analyzer

    # C/C++
    gcc

    # AI tools
    claude-code

    # Code editors
    vscode
    micro
    vim
  ];
}
