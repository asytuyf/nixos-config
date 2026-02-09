# ❄️ My NixOS Configuration

My personal NixOS setup. Fully portable - works on any machine from VMs to laptops to desktops.

## 📁 Structure

```
/etc/nixos/
├── flake.nix                    # Flake setup with nixpkgs + home-manager + sops-nix
├── flake.lock                   # Locked dependency versions
├── configuration.nix            # Main system config (imports everything)
├── hardware-configuration.nix   # ⚠️ NOT in git (auto-generated per machine)
│
├── modules/                     # System-level config
│   ├── desktop.nix             # GNOME, GDM, pipewire, printing
│   ├── development.nix         # Dev tools (git, nodejs, rust, gcc, etc.)
│   ├── packages.nix            # Everything else I use
│   ├── shell.nix               # Zsh as default shell
│   └── secrets.nix             # Secrets management (sops-nix)
│
├── home/                        # My user environment (home-manager)
│   ├── abdo.nix                # Entry point
│   └── modules/
│       ├── git.nix             # Git username/email
│       ├── gnome.nix           # Keybindings (Super+S = screenshot)
│       └── zsh.nix             # Shell config + all my custom functions
│
├── secrets/                     # Encrypted secrets (safe to commit!)
│   └── secrets.yaml            # Encrypted with sops
│
├── .sops.yaml                   # Sops configuration
│
└── rice-themes/                 # Theme configurations
    └── htop/                   # Htop themes (managed by dotwell)
        ├── blue/
        ├── red/
        ├── green/
        └── default/
```

## 🛠️ My Custom Commands

All defined in `home/modules/zsh.nix`:

- **`nsync "message"`** - Rebuild system + commit + push to GitHub
- **`addcmd <command>`** - Save command snippet to my vault
- **`vault-sync`** - Deploy vault updates to Vercel
- **`addgoal "task"`** - Add goal to project tracker
- **`editgoals`** - Edit goals manually
- **`mycmds`** - View my command cheatsheet
- **`dwell`** - Run my dotwell theme manager

## 🔐 Secrets Management

Using **sops-nix** to encrypt sensitive data (SSH keys, API tokens, etc.).

### First Time Setup

1. **Generate an age key:**
```bash
cd /etc/nixos
./setup-secrets.sh
```

2. **Update .sops.yaml with your public key:**
```bash
sudo micro .sops.yaml
# Replace REPLACE_WITH_YOUR_AGE_PUBLIC_KEY with your actual public key
```

3. **Add your secrets:**
```bash
sudo sops secrets/secrets.yaml
# Add your secrets, save and exit
```

4. **Commit:**
```bash
nsync "Add secrets"
```

### Using Secrets

Once encrypted, your secrets are safe to commit to GitHub! They'll be decrypted automatically at boot.

Example - Add SSH key:
```nix
# In modules/secrets.nix
sops.secrets."ssh-private-key" = {
  owner = "abdo";
  path = "/home/abdo/.ssh/id_ed25519";
  mode = "0600";
};
```

## 🎨 Themes

Rice themes organized by application:
- `htop/` - Htop color schemes (blue, red, green, default)
- Managed by my `dwell` tool
- Future: can add themes for other apps

## 🚀 Usage

### Rebuild & Sync
```bash
nsync "what I changed"
```

### Add New Module
1. Create a `.nix` file in `modules/` or `home/modules/`
2. Add it to imports in `configuration.nix` or `home/abdo.nix`
3. Run `nsync`

### Edit Secrets
```bash
sudo sops secrets/secrets.yaml
```

## 📦 What's Tracked

✅ All packages with exact versions  
✅ System configuration (GNOME, services, locale)  
✅ User environment (shell, aliases, functions)  
✅ Git config  
✅ GNOME keybindings  
✅ Encrypted secrets  
✅ Theme configurations  
❌ Hardware config (auto-generated per machine)

## 🔄 Migrating to New Machine (Fully Automatic!)

1. **Install NixOS** (auto-generates hardware-configuration.nix)

2. **Clone config:**
   ```bash
   sudo rm -rf /etc/nixos  # Remove default config
   sudo git clone https://github.com/yourusername/nixos-config /etc/nixos
   ```

3. **Restore secrets key:**
   ```bash
   sudo mkdir -p /var/lib/sops-nix
   sudo cp /path/to/backup/sops-key.txt /var/lib/sops-nix/key.txt
   sudo chmod 600 /var/lib/sops-nix/key.txt
   ```

4. **Build system:**
   ```bash
   cd /etc/nixos
   sudo nixos-rebuild switch --flake .#nixos
   ```

5. **Set password:**
   ```bash
   passwd
   ```

**Done!** Your exact system is recreated with new machine's hardware config.

## 🔄 Maintenance

- **Update packages**: `nix flake update` then `nsync`
- **Garbage collect**: Automatic daily (keeps 10 days)
- **Auto-upgrade**: Weekly

## 💡 How Portability Works

**Portable (in git):**
- All your system config
- Encrypted secrets
- User environment

**Machine-specific (not in git):**
- hardware-configuration.nix (auto-generated on install)
- Sops private key (backed up separately)
- User password (set with `passwd`)

Each machine gets its own hardware config, but uses your system config!

## 📝 Notes to Self

- Old `home.nix` can be deleted once confirmed working
- Personal projects (directory_website, dotwell) are separate repos
- System is on NixOS 25.11
- Keep `/var/lib/sops-nix/key.txt` backed up on USB/cloud!

---
