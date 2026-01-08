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

# 6. Install NVM
export NVM_DIR="$HOME/.nvm"

# 6.1. Check if NVM is already installed
if [ -d "$NVM_DIR" ]; then
    echo "✅ NVM is already installed."
else
    echo "⬇️  Installing NVM..."
    
    # 6.2. Fetch the latest version tag from GitHub API
    LATEST_NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    # 6.3. Download and run the install script
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_NVM_VERSION}/install.sh" | bash
    
    echo "✅ NVM installed ($LATEST_NVM_VERSION)"

    # 6.4. Load NVM into the current shell session immediately
    #    (This allows you to use 'nvm install' in the very next line of this script)
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # 6.5 Install LTS Node version immediately
    nvm install --lts
    nvm use --lts
fi

PACKAGE_NAME="@google/gemini-cli"

# 6.6 Check if the package is already installed globally
if npm list -g "$PACKAGE_NAME" > /dev/null 2>&1; then
    echo "✅ $PACKAGE_NAME is already installed."
else
    echo "⬇️  Installing $PACKAGE_NAME..."
    npm install -g "$PACKAGE_NAME"
    echo "✅ $PACKAGE_NAME installed successfully."
fi

# 7. Check if the 'claude' command exists
if command -v claude >/dev/null 2>&1; then
    echo "✅ Claude Code is already installed."
else
    echo "⬇️  Installing Claude Code (Official Script)..."
    # Official installer from Anthropic
    curl -L https://claude.ai/install | sh
    
    echo "✅ Claude Code installed."
fi

# 8. Install Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install Plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# 9. Change Shell
echo "🔄 Changing default shell to Zsh..."
sudo chsh -s $(which zsh) $USER

ln -sf ~/dotfiles/vimrc ~/.vimrc
echo "✅ Done! Restart your terminal."

