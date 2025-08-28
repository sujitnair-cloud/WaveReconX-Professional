# WaveReconX Professional - Makefile
# Enhanced RF Spectrum Analysis Tool

.PHONY: help install install-dev test clean lint format docs run build

# Default target
help:
	@echo "WaveReconX Professional - Available Commands:"
	@echo ""
	@echo "  install     - Install production dependencies"
	@echo "  install-dev - Install development dependencies"
	@echo "  test        - Run tests"
	@echo "  lint        - Run linting checks"
	@echo "  format      - Format code with black"
	@echo "  docs        - Build documentation"
	@echo "  run         - Run the application"
	@echo "  clean       - Clean build artifacts"
	@echo "  build       - Build distribution package"
	@echo "  setup       - Setup development environment"

# Install production dependencies
install:
	pip install -r requirements/requirements.txt

# Install development dependencies
install-dev:
	pip install -e ".[dev,docs,full]"

# Setup development environment
setup: install-dev
	@echo "Setting up development environment..."
	mkdir -p data/exports data/backups logs
	@echo "Development environment setup complete!"

# Run tests
test:
	pytest tests/ -v --cov=src --cov-report=html

# Run linting
lint:
	flake8 src/ tests/ --max-line-length=100 --ignore=E203,W503
	mypy src/ --ignore-missing-imports

# Format code
format:
	black src/ tests/ --line-length=100

# Build documentation
docs:
	cd docs && make html

# Run the application
run:
	python main.py

# Clean build artifacts
clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf __pycache__/
	rm -rf src/__pycache__/
	rm -rf src/*/__pycache__/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} +

# Build distribution package
build: clean
	python setup.py sdist bdist_wheel

# Install system dependencies (Ubuntu/Debian)
install-system-deps:
	sudo apt-get update
	sudo apt-get install -y \
		rtl-sdr \
		gr-osmosdr \
		gnuradio \
		libusb-1.0-0-dev \
		cmake \
		build-essential \
		python3-dev \
		python3-pip

# Setup udev rules for SDR devices
setup-udev:
	@echo "Setting up udev rules for SDR devices..."
	sudo cp config/99-rtlsdr.rules /etc/udev/rules.d/
	sudo udevadm control --reload-rules
	sudo udevadm trigger
	@echo "Udev rules setup complete!"

# Create virtual environment
venv:
	python3 -m venv venv
	@echo "Virtual environment created. Activate with: source venv/bin/activate"

# Backup current configuration
backup-config:
	@echo "Backing up configuration..."
	mkdir -p config/backup
	cp config/settings.json config/backup/settings_$(shell date +%Y%m%d_%H%M%S).json
	@echo "Configuration backed up!"

# Restore configuration from backup
restore-config:
	@echo "Available backups:"
	@ls -la config/backup/
	@echo "Usage: make restore-config BACKUP=filename"

# Check system requirements
check-system:
	@echo "Checking system requirements..."
	@python3 -c "import sys; print(f'Python version: {sys.version}')"
	@which rtl_test > /dev/null && echo "RTL-SDR tools: OK" || echo "RTL-SDR tools: NOT FOUND"
	@lsusb | grep -i rtl > /dev/null && echo "RTL-SDR device: DETECTED" || echo "RTL-SDR device: NOT DETECTED"
	@echo "System check complete!"

# Generate requirements from current environment
freeze:
	pip freeze > requirements/requirements_frozen.txt
	@echo "Frozen requirements saved to requirements/requirements_frozen.txt"

# Update requirements
update-requirements:
	pip install --upgrade -r requirements/requirements.txt
	make freeze

# Security check
security-check:
	bandit -r src/ -f json -o security_report.json
	@echo "Security check complete. See security_report.json for details."

# Performance profiling
profile:
	python -m cProfile -o profile_output.prof main.py
	@echo "Profiling complete. Use snakeviz profile_output.prof to view results."

# Docker build
docker-build:
	docker build -t wave-recon-x .

# Docker run
docker-run:
	docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb wave-recon-x

# Git hooks setup
setup-hooks:
	@echo "Setting up git hooks..."
	cp scripts/pre-commit .git/hooks/
	chmod +x .git/hooks/pre-commit
	@echo "Git hooks setup complete!"
