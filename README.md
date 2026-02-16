# My NixOS Configuration

Personal NixOS setup for x86_64 systems (Intel/AMD).

## Structure

```
/etc/nixos/
├── flake.nix                    # Flake entry point
├── configuration.nix            # Main config (imports modules)
├── hardware-configuration.nix   # Auto-generated per machine (not in git)
├── modules/                     # System config
│   ├── desktop.nix              # GNOME, GDM, pipewire
│   ├── development.nix          # Dev tools (git, nodejs, rust, etc.)
│   ├── packages.nix             # Apps (spotify, steam, etc.)
│   ├── bspwm-packages.nix       # bspwm/gh0stzk dotfiles packages
│   ├── hyprland.nix             # Hyprland wayland compositor
│   ├── shell.nix                # Zsh as default
│   └── secrets.nix              # sops-nix secrets
├── home/                        # Home-manager config
│   ├── abdo.nix                 # Entry point
│   └── modules/                 # User-level modules
└── secrets/                     # Encrypted secrets (safe to commit)
```

## Usage

**Rebuild & sync:**
```bash
nsync "what I changed"
```

**Update packages:**
```bash
nix flake update && nsync "update packages"
```

## New Machine Setup

1. Install NixOS (generates hardware-configuration.nix)
2. Clone this repo:
   ```bash
   sudo rm -rf /etc/nixos/*
   sudo git clone https://github.com/YOUR_USERNAME/nixos-config /etc/nixos
   ```
3. Keep the generated `hardware-configuration.nix`
4. Restore sops key to `/var/lib/sops-nix/key.txt`
5. Build:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#nixos
   ```

## Notes

- x86_64-linux only (Intel/AMD)
- NixOS 25.11
- Auto garbage collection (daily, keeps 10 days)
- Auto upgrades (weekly)
