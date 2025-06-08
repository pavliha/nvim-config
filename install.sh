#!/bin/bash

# Portable Neovim Installation Script
# This script installs Neovim and your custom configuration on any Linux system

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_not_root() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Please don't run this script as root!"
        exit 1
    fi
}

# Detect system architecture
detect_arch() {
    local arch=$(uname -m)
    case $arch in
        x86_64)
            echo "linux64"
            ;;
        aarch64|arm64)
            echo "linux-arm64"
            ;;
        armv7l)
            echo "linux-arm32"
            ;;
        *)
            print_error "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    else
        echo "unknown"
    fi
}

# Install dependencies based on distribution
install_dependencies() {
    local distro=$(detect_distro)
    print_info "Detected distribution: $distro"
    
    case $distro in
        ubuntu|debian|raspbian)
            print_info "Installing dependencies for Debian/Ubuntu..."
            sudo apt update
            sudo apt install -y curl git build-essential cmake ninja-build gettext unzip \
                ripgrep fd-find nodejs npm python3-pip make gcc
            
            # Create fd symlink if it doesn't exist
            if ! command -v fd &> /dev/null; then
                sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true
            fi
            ;;
        fedora|rhel|centos)
            print_info "Installing dependencies for Red Hat/Fedora..."
            sudo dnf install -y curl git cmake ninja-build gettext unzip \
                ripgrep fd-find nodejs npm python3-pip make gcc-c++
            ;;
        arch|manjaro)
            print_info "Installing dependencies for Arch Linux..."
            sudo pacman -S --noconfirm curl git cmake ninja gettext unzip \
                ripgrep fd nodejs npm python-pip make gcc
            ;;
        alpine)
            print_info "Installing dependencies for Alpine Linux..."
            sudo apk add --no-cache curl git cmake ninja gettext unzip \
                ripgrep fd nodejs npm python3 py3-pip make gcc g++ musl-dev
            ;;
        *)
            print_warning "Unknown distribution. Please install these dependencies manually:"
            echo "  - curl, git, cmake, ninja-build, gettext, unzip"
            echo "  - ripgrep, fd-find, nodejs, npm, python3, pip"
            echo "  - make, gcc, build tools"
            read -p "Press Enter to continue or Ctrl+C to exit..."
            ;;
    esac
}

# Install Neovim
install_neovim() {
    print_info "Installing Neovim..."
    
    local arch=$(detect_arch)
    local nvim_version="stable"
    
    # Remove old Neovim installations
    sudo rm -f /usr/local/bin/nvim
    sudo rm -rf /opt/nvim
    
    case $arch in
        linux64|linux-arm64)
            # Try AppImage first
            print_info "Downloading Neovim AppImage for $arch..."
            local appimage_url="https://github.com/neovim/neovim/releases/latest/download/nvim-${arch}.appimage"
            
            if curl -fsSL "$appimage_url" -o nvim.appimage; then
                chmod u+x nvim.appimage
                
                # Test if AppImage works
                if ./nvim.appimage --version &>/dev/null; then
                    sudo mv nvim.appimage /usr/local/bin/nvim
                    print_success "Neovim AppImage installed successfully"
                    return 0
                else
                    print_warning "AppImage doesn't work, trying tarball..."
                    rm -f nvim.appimage
                fi
            fi
            
            # Fallback to tarball
            print_info "Downloading Neovim tarball for $arch..."
            local tarball_url="https://github.com/neovim/neovim/releases/latest/download/nvim-${arch}.tar.gz"
            
            curl -fsSL "$tarball_url" -o nvim.tar.gz
            tar xzf nvim.tar.gz
            sudo mv nvim-${arch} /opt/nvim
            sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
            rm -f nvim.tar.gz
            print_success "Neovim tarball installed successfully"
            ;;
        *)
            # Build from source for other architectures
            print_info "Building Neovim from source for $arch..."
            build_neovim_from_source
            ;;
    esac
}

# Build Neovim from source
build_neovim_from_source() {
    print_info "Building Neovim from source (this may take a while)..."
    
    # Clone Neovim repository
    if [ -d "neovim" ]; then
        rm -rf neovim
    fi
    
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout stable
    
    # Build and install
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    
    cd ..
    rm -rf neovim
    print_success "Neovim built and installed from source"
}

# Install Go (needed for templ and gopls)
install_go() {
    if command -v go &> /dev/null; then
        print_info "Go is already installed: $(go version)"
        return 0
    fi
    
    print_info "Installing Go..."
    local arch=$(uname -m)
    local go_arch=""
    
    case $arch in
        x86_64) go_arch="amd64" ;;
        aarch64|arm64) go_arch="arm64" ;;
        armv7l) go_arch="armv6l" ;;
        *) print_error "Unsupported architecture for Go: $arch"; return 1 ;;
    esac
    
    local go_version="1.21.5"
    local go_url="https://golang.org/dl/go${go_version}.linux-${go_arch}.tar.gz"
    
    curl -fsSL "$go_url" -o go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go.tar.gz
    rm go.tar.gz
    
    # Add Go to PATH if not already there
    if ! echo $PATH | grep -q "/usr/local/go/bin"; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
        export PATH=$PATH:/usr/local/go/bin
        export PATH=$PATH:$(go env GOPATH)/bin
    fi
    
    print_success "Go installed successfully"
}

# Install Go tools
install_go_tools() {
    print_info "Installing Go development tools..."
    
    # Make sure Go is in PATH
    export PATH=$PATH:/usr/local/go/bin:$(go env GOPATH)/bin
    
    # Install essential Go tools
    go install golang.org/x/tools/gopls@latest
    go install github.com/a-h/templ/cmd/templ@latest
    go install github.com/mgechev/revive@latest
    go install golang.org/x/tools/cmd/goimports@latest
    
    print_success "Go tools installed"
}

# Install LSP servers
install_lsp_servers() {
    print_info "Installing LSP servers..."
    
    # Install Node.js based LSP servers
    sudo npm install -g \
        typescript-language-server \
        vscode-langservers-extracted \
        bash-language-server \
        yaml-language-server \
        dockerfile-language-server-nodejs
    
    print_success "LSP servers installed"
}

# Backup existing Neovim configuration
backup_existing_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        local backup_dir="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing Neovim config to $backup_dir"
        mv "$HOME/.config/nvim" "$backup_dir"
    fi
}

# Install Neovim configuration
install_nvim_config() {
    print_info "Installing Neovim configuration from GitHub repository..."
    
    # Configuration repository details
    local config_repo="https://github.com/pavliha/nvim-config.git"
    
    # Clone the configuration
    print_info "Cloning configuration from $config_repo..."
    
    if [ -d "nvim-config-temp" ]; then
        rm -rf nvim-config-temp
    fi
    
    if git clone "$config_repo" nvim-config-temp; then
        # Create config directory
        mkdir -p "$HOME/.config/nvim"
        
        # Copy all configuration files
        cp -r nvim-config-temp/* "$HOME/.config/nvim/"
        
        # Clean up temporary directory
        rm -rf nvim-config-temp
        
        print_success "Neovim configuration cloned and installed successfully"
    else
        print_error "Failed to clone configuration repository"
        print_error "Please check your internet connection and try again."
        exit 1
    fi
    
    # Set proper permissions
    chmod 644 "$HOME/.config/nvim"/* 2>/dev/null || true
    
    print_info "Configuration files installed to ~/.config/nvim/"
}

# Post-installation setup
post_install_setup() {
    print_info "Running post-installation setup..."
    
    # Update PATH for current session
    export PATH=$PATH:/usr/local/go/bin:$(go env GOPATH)/bin 2>/dev/null || true
    
    print_info "Opening Neovim to trigger plugin installation..."
    print_info "Neovim will install plugins automatically in the background."
    print_info "Press Enter to continue..."
    read
    
    # Open Neovim briefly to trigger lazy.nvim plugin installation
    nvim --headless "+Lazy! sync" +qa
    
    print_success "✅ Installation completed successfully!"
    echo
    print_info "🎉 Your Neovim setup is ready!"
    echo
    print_info "📝 Configuration pulled from: https://github.com/pavliha/nvim-config"
    print_info "📁 Config location: ~/.config/nvim/"
    print_info "🔧 Tools installed: Neovim, Go, LSP servers, development tools"
    echo
    print_info "🚀 Essential Keybindings:"
    echo "   <Space>ff  - Find files"
    echo "   <Space>fg  - Live grep" 
    echo "   <Space>fb  - Switch buffers"
    echo "   <Space>e   - Toggle file explorer"
    echo "   <Space>w   - Save file"
    echo "   <Ctrl+\\>  - Toggle terminal"
    echo "   gcc        - Comment/uncomment line"
    echo
    print_info "Run 'nvim' to start editing!"
    
    # Add environment variables to shell profile if not already there
    local shell_profile=""
    if [ -n "$ZSH_VERSION" ]; then
        shell_profile="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        shell_profile="$HOME/.bashrc"
    fi
    
    if [ -n "$shell_profile" ] && [ -f "$shell_profile" ]; then
        if ! grep -q "/usr/local/go/bin" "$shell_profile"; then
            echo "" >> "$shell_profile"
            echo "# Added by Neovim installer" >> "$shell_profile"
            echo 'export PATH=$PATH:/usr/local/go/bin' >> "$shell_profile"
            echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> "$shell_profile"
            print_info "Updated $shell_profile with Go paths"
            print_warning "Please run 'source $shell_profile' or restart your terminal"
        fi
    fi
}

# Main installation function
main() {
    print_info "🚀 Starting Neovim Installation Script"
    echo
    
    # Check if not running as root
    check_not_root
    
    # Detect system
    local arch=$(detect_arch)
    local distro=$(detect_distro)
    print_info "System: $distro ($arch)"
    echo
    
    # Ask for confirmation
    print_info "This script will install:"
    echo "  • Neovim (latest stable version)"
    echo "  • Go programming language"
    echo "  • Development dependencies"
    echo "  • LSP servers and Go tools"
    echo "  • Your Neovim configuration from GitHub"
    echo
    read -p "Do you want to continue? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi
    echo
    
    # Backup existing config
    backup_existing_config
    
    # Install dependencies
    install_dependencies
    
    # Install Neovim
    install_neovim
    
    # Verify Neovim installation
    if ! command -v nvim &> /dev/null; then
        print_error "Neovim installation failed!"
        exit 1
    fi
    
    local nvim_version=$(nvim --version | head -n1)
    print_success "Neovim installed: $nvim_version"
    
    # Install Go
    install_go
    
    # Install Go tools
    install_go_tools
    
    # Install LSP servers
    install_lsp_servers
    
    # Install Neovim configuration
    install_nvim_config
    
    # Post-installation setup
    post_install_setup
}

# Run the main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
