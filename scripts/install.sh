#!/bin/bash

# WaveReconX Professional - Installation Script
# Enhanced RF Spectrum Analysis Tool

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Python version
check_python_version() {
    if command_exists python3; then
        python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
        required_version="3.8"
        
        if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" = "$required_version" ]; then
            print_success "Python $python_version found (>= $required_version required)"
            return 0
        else
            print_error "Python $python_version found, but $required_version or higher is required"
            return 1
        fi
    else
        print_error "Python3 not found"
        return 1
    fi
}

# Function to install system dependencies
install_system_deps() {
    print_status "Installing system dependencies..."
    
    if command_exists apt-get; then
        # Ubuntu/Debian
        sudo apt-get update
        sudo apt-get install -y \
            rtl-sdr \
            gr-osmosdr \
            gnuradio \
            libusb-1.0-0-dev \
            cmake \
            build-essential \
            python3-dev \
            python3-pip \
            python3-tk \
            git
    elif command_exists yum; then
        # CentOS/RHEL
        sudo yum update
        sudo yum install -y \
            rtl-sdr \
            gnuradio \
            libusb1-devel \
            cmake \
            gcc \
            python3-devel \
            python3-pip \
            python3-tkinter \
            git
    elif command_exists dnf; then
        # Fedora
        sudo dnf update
        sudo dnf install -y \
            rtl-sdr \
            gnuradio \
            libusb1-devel \
            cmake \
            gcc \
            python3-devel \
            python3-pip \
            python3-tkinter \
            git
    else
        print_error "Unsupported package manager. Please install dependencies manually."
        return 1
    fi
    
    print_success "System dependencies installed"
}

# Function to setup udev rules
setup_udev_rules() {
    print_status "Setting up udev rules for SDR devices..."
    
    # Create udev rules file
    sudo tee /etc/udev/rules.d/99-rtlsdr.rules > /dev/null <<EOF
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="plugdev", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", GROUP="plugdev", MODE="0666"
EOF
    
    # Reload udev rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    
    # Add user to plugdev group
    sudo usermod -a -G plugdev $USER
    
    print_success "Udev rules configured"
    print_warning "Please log out and log back in for group changes to take effect"
}

# Function to create virtual environment
create_venv() {
    print_status "Creating virtual environment..."
    
    if [ -d "venv" ]; then
        print_warning "Virtual environment already exists. Removing..."
        rm -rf venv
    fi
    
    python3 -m venv venv
    print_success "Virtual environment created"
}

# Function to install Python dependencies
install_python_deps() {
    print_status "Installing Python dependencies..."
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install dependencies
    if [ "$1" = "dev" ]; then
        print_status "Installing development dependencies..."
        pip install -e ".[dev,docs,full]"
    else
        print_status "Installing production dependencies..."
        pip install -r requirements/requirements.txt
    fi
    
    print_success "Python dependencies installed"
}

# Function to setup project structure
setup_project_structure() {
    print_status "Setting up project structure..."
    
    # Create necessary directories
    mkdir -p data/exports data/backups logs
    
    # Set permissions
    chmod 755 data logs
    chmod 644 config/settings.json
    
    print_success "Project structure created"
}

# Function to test SDR device
test_sdr_device() {
    print_status "Testing SDR device..."
    
    if command_exists rtl_test; then
        if rtl_test > /dev/null 2>&1; then
            print_success "SDR device test passed"
        else
            print_warning "SDR device test failed. Check device connection and permissions."
        fi
    else
        print_warning "rtl_test not found. Skipping SDR device test."
    fi
}

# Function to verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    # Check Python imports
    source venv/bin/activate
    python3 -c "
import sys
import tkinter
import numpy
import pandas
import requests
import sqlite3
print('All core dependencies imported successfully')
" && print_success "Python dependencies verified" || print_error "Python dependency verification failed"
    
    # Test application startup
    if python3 -c "from src.core.wave_recon_x import WaveReconXEnhanced; print('Application import successful')" 2>/dev/null; then
        print_success "Application import verified"
    else
        print_error "Application import failed"
        return 1
    fi
}

# Function to display next steps
display_next_steps() {
    echo
    print_success "Installation completed successfully!"
    echo
    echo "Next steps:"
    echo "1. Activate virtual environment: source venv/bin/activate"
    echo "2. Run the application: python main.py"
    echo "3. Read the documentation: docs/user_guide/"
    echo "4. Configure settings: config/settings.json"
    echo
    echo "For development:"
    echo "1. Install dev dependencies: pip install -e '.[dev,docs,full]'"
    echo "2. Run tests: make test"
    echo "3. Format code: make format"
    echo
    print_warning "Remember to log out and log back in for SDR device permissions to take effect"
}

# Main installation function
main() {
    echo "🛡️  WaveReconX Professional - Installation Script"
    echo "=================================================="
    echo
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run this script as root"
        exit 1
    fi
    
    # Check Python version
    if ! check_python_version; then
        print_error "Python version check failed"
        exit 1
    fi
    
    # Install system dependencies
    if ! install_system_deps; then
        print_error "System dependency installation failed"
        exit 1
    fi
    
    # Setup udev rules
    setup_udev_rules
    
    # Create virtual environment
    create_venv
    
    # Install Python dependencies
    install_python_deps "$1"
    
    # Setup project structure
    setup_project_structure
    
    # Test SDR device
    test_sdr_device
    
    # Verify installation
    if ! verify_installation; then
        print_error "Installation verification failed"
        exit 1
    fi
    
    # Display next steps
    display_next_steps
}

# Parse command line arguments
case "${1:-}" in
    "dev")
        main "dev"
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [dev|help]"
        echo "  dev   - Install with development dependencies"
        echo "  help  - Show this help message"
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
