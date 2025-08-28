#!/usr/bin/env python3
"""
WaveReconX Professional - Main Application Entry Point
Enhanced RF Spectrum Analysis Tool

This is the main entry point for the WaveReconX Professional application.
It initializes the GUI and starts the application.
"""

import sys
import os
import logging
from pathlib import Path

# Add the src directory to the Python path
project_root = Path(__file__).parent
src_path = project_root / "src"
sys.path.insert(0, str(src_path))

# Import the main application
from core.wave_recon_x import WaveReconXEnhanced

def setup_logging():
    """Setup logging configuration for the application."""
    log_dir = project_root / "logs"
    log_dir.mkdir(exist_ok=True)
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_dir / "wave_recon_x.log"),
            logging.StreamHandler (sys.stdout)
        ]
    )

def check_dependencies():
    """Check if required dependencies are available."""
    try:
        import tkinter
        import numpy
        import pandas
        import requests
        import sqlite3
        logging.info("Core dependencies check passed")
        return True
    except ImportError as e:
        logging.error(f"Missing dependency: {e}")
        print(f"❌ Missing dependency: {e}")
        print("Please install required dependencies:")
        print("pip install -r requirements/requirements.txt")
        return False

def check_hardware():
    """Check if SDR hardware is available."""
    try:
        import rtlsdr
        sdr = rtlsdr.RtlSdr()
        sdr.close()
        logging.info("SDR hardware check passed")
        return True
    except Exception as e:
        logging.warning(f"SDR hardware not available: {e}")
        print("⚠️  SDR hardware not detected")
        print("The application will run in simulation mode")
        return False

def main():
    """Main application entry point."""
    print("🛡️  WaveReconX Professional - Enhanced RF Spectrum Analysis Tool")
    print("=" * 60)
    
    # Setup logging
    setup_logging()
    logging.info("Starting WaveReconX Professional")
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    # Check hardware
    hardware_available = check_hardware()
    
    try:
        # Initialize and start the application
        app = WaveReconXEnhanced()
        
        # Set hardware status
        if not hardware_available:
            app.set_simulation_mode()
        
        print("✅ Application initialized successfully")
        print("🚀 Starting GUI...")
        
        # Start the main event loop
        app.run()
        
    except Exception as e:
        logging.error(f"Application startup failed: {e}")
        print(f"❌ Application startup failed: {e}")
        sys.exit(1)
    
    finally:
        logging.info("Application shutdown complete")

if __name__ == "__main__":
    main()
