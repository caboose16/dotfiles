#!/bin/bash

# Idempotent Master Script

# 1. Update & Essentials
echo "📦 Updating system..."
sudo apt update && sudo apt install -y git curl unzip fontconfig bat zsh

# 2. Link Configs (The Magic)
echo "🔗 Linking dotfiles..."
# Delete existing default files if they exist
rm -rf ~/.zshrc ~/.vimrc ~/.config/starship.toml ~/.config/zellij

# Create symlinks
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/vimrc ~/.vimrc
mkdir -p ~/.config
ln -sf ~/dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/config/zellij ~/.config/zellij

# 3. Install Starship
if ! command -v starship &> /dev/null; then
    echo "🚀 Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# 4. Install Zoxide
if ! command -v zoxide &> /dev/null; then
    echo "📂 Installing Zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# 5. Install Zellij
if ! command -v zellij &> /dev/null; then
    echo "🪟 Installing Zellij..."
    sudo curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -xz
    sudo mv zellij /usr/local/bin/
fi

# 6. Install Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install Plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# 7. Change Shell
echo "🔄 Changing default shell to Zsh..."
sudo chsh -s $(which zsh) $USER

echo "✅ Done! Restart your terminal."
