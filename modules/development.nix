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
    gemini-cli-bin
    opencode
    antigravity

    # Code editors

    # LaTeX (for PDF notes generation)
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        latex
        xetex
        latexmk
        collection-latexextra
        collection-fontsrecommended
        collection-mathscience
        parskip
        geometry
        fancyhdr
        hyperref
        xcolor
        tcolorbox
        pgf
        tikzfill
        framed
        mdframed
        environ
        etoolbox;
    })
    pandoc

    vscode
    micro
    vim
  ];
}
