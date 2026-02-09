#!/usr/bin/env bash
# Setup script for sops-nix secrets management

set -e

echo "🔐 Setting up sops-nix secrets management..."
echo ""

# Check if age key already exists
if [ -f /var/lib/sops-nix/key.txt ]; then
    echo "✅ Age key already exists at /var/lib/sops-nix/key.txt"
    echo ""
    echo "Your PUBLIC key is:"
    sudo cat /var/lib/sops-nix/key.txt | grep "public key:"
else
    echo "📝 Generating new age encryption key..."
    sudo mkdir -p /var/lib/sops-nix
    sudo age-keygen -o /var/lib/sops-nix/key.txt
    
    echo ""
    echo "✅ Age key generated!"
    echo ""
    echo "🔑 Your PUBLIC key (copy this):"
    sudo cat /var/lib/sops-nix/key.txt | grep "public key:"
    echo ""
    echo "⚠️  IMPORTANT: Back up your PRIVATE key!"
    echo "   Location: /var/lib/sops-nix/key.txt"
    echo "   Copy it to USB/cloud for recovery"
fi

echo ""
echo "📋 Next steps:"
echo "1. Edit .sops.yaml and replace REPLACE_WITH_YOUR_AGE_PUBLIC_KEY with your public key above"
echo "2. Run: sudo sops /etc/nixos/secrets/secrets.yaml"
echo "3. Add your secrets, save and exit"
echo "4. Run: nsync 'Add secrets management'"
echo ""
echo "Done! 🎉"
