# WaveReconX Professional - Installation Guide

## Prerequisites

### System Requirements
- **Operating System**: Linux (Ubuntu 20.04+ recommended)
- **Python**: 3.8 or higher
- **RAM**: Minimum 4GB, 8GB recommended
- **Storage**: 2GB free space
- **Hardware**: RTL-SDR or compatible SDR device

### Hardware Requirements
- **RTL-SDR**: RTL2832U-based USB dongle
- **Antenna**: Compatible antenna for target frequency bands
- **USB Port**: USB 2.0 or higher

## Installation Steps

### 1. System Dependencies

Install required system packages:

```bash
# Update package list
sudo apt-get update

# Install system dependencies
sudo apt-get install -y \
    rtl-sdr \
    gr-osmosdr \
    gnuradio \
    libusb-1.0-0-dev \
    cmake \
    build-essential \
    python3-dev \
    python3-pip \
    git
```

### 2. Clone the Repository

```bash
git clone https://github.com/wave-recon-x/wave-recon-x.git
cd wave-recon-x
```

### 3. Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate
```

### 4. Install Python Dependencies

```bash
# Install production dependencies
pip install -r requirements/requirements.txt

# Or install with development tools
pip install -e ".[dev,docs,full]"
```

### 5. Setup SDR Device

#### Configure udev rules for SDR access:

```bash
# Create udev rules file
sudo tee /etc/udev/rules.d/99-rtlsdr.rules > /dev/null <<EOF
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="plugdev", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", GROUP="plugdev", MODE="0666"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```

#### Add user to plugdev group:

```bash
sudo usermod -a -G plugdev $USER
```

**Note**: Log out and log back in for group changes to take effect.

### 6. Test SDR Device

```bash
# Test RTL-SDR device
rtl_test

# Expected output should show device information
```

### 7. Verify Installation

```bash
# Run system check
make check-system

# Test the application
python main.py
```

## Quick Start

### Using Makefile (Recommended)

```bash
# Setup complete development environment
make setup

# Run the application
make run

# Check system requirements
make check-system
```

### Manual Setup

```bash
# Install dependencies
pip install -r requirements/requirements.txt

# Create necessary directories
mkdir -p data/exports data/backups logs

# Run application
python main.py
```

## Configuration

### Initial Configuration

1. The application will create default configuration files on first run
2. Edit `config/settings.json` to customize settings
3. Configure your SDR device parameters
4. Set frequency bands for scanning

### Configuration Options

- **SDR Device**: Select your SDR hardware
- **Frequency Bands**: Configure GSM, LTE, UMTS, 5G bands
- **Scan Settings**: Adjust step size, dwell time, threshold
- **Output Formats**: Choose CSV, JSON, XML export formats

## Troubleshooting

### Common Issues

#### 1. Permission Denied for SDR Device

```bash
# Check device permissions
ls -la /dev/bus/usb/

# Fix permissions
sudo chmod 666 /dev/bus/usb/XXX/YYY
```

#### 2. RTL-SDR Not Detected

```bash
# Check USB devices
lsusb | grep -i rtl

# Test device
rtl_test

# Check kernel modules
lsmod | grep rtl
```

#### 3. Python Import Errors

```bash
# Reinstall dependencies
pip install --force-reinstall -r requirements/requirements.txt

# Check Python version
python3 --version
```

#### 4. GUI Not Starting

```bash
# Check tkinter installation
python3 -c "import tkinter; print('tkinter OK')"

# Install tkinter if missing
sudo apt-get install python3-tk
```

### Getting Help

- Check the logs in `logs/wave_recon_x.log`
- Review the documentation in `/docs`
- Submit issues on GitHub
- Contact the development team

## Next Steps

After successful installation:

1. **Read the User Guide**: `/docs/user_guide/`
2. **Configure Settings**: Edit `config/settings.json`
3. **Test Hardware**: Run spectrum scan
4. **Explore Features**: Try different analysis modes

## Uninstallation

To remove WaveReconX Professional:

```bash
# Remove Python package
pip uninstall wave-recon-x

# Remove project directory
rm -rf /path/to/wave-recon-x

# Remove udev rules (optional)
sudo rm /etc/udev/rules.d/99-rtlsdr.rules
```
