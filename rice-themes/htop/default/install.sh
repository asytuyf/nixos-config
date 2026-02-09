#!/bin/bash
# Restore default htop theme

echo "🔄 Restoring default htop configuration..."
cp htoprc ~/.config/htop/htoprc
echo "✓ Default theme restored! Run 'htop' to see it."
