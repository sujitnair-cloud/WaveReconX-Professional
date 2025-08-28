#!/usr/bin/env python3
"""
WaveReconX Professional - Replit-Compatible Version
Enhanced RF Spectrum Analysis Tool

This is the Replit-compatible entry point for the WaveReconX Professional application.
It handles environment differences and provides fallbacks for SDR functionality.
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
            logging.FileHandler(log_dir / "wave_recon_x_replit.log"),
            logging.StreamHandler(sys.stdout)
        ]
    )

def check_replit_environment():
    """Check if running in Replit environment and set appropriate flags."""
    is_replit = os.environ.get('REPL_ID') is not None
    if is_replit:
        print("🔄 Detected Replit environment")
        print("📝 Note: SDR hardware functionality will be limited")
        print("🎯 Educational and analysis features will work normally")
        return True
    return False

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
        print("pip install -r requirements-replit.txt")
        return False

def check_hardware():
    """Check if SDR hardware is available (will be limited in Replit)."""
    try:
        # In Replit, we'll simulate SDR availability for educational purposes
        if os.environ.get('REPL_ID'):
            print("🎓 Replit Environment: Using educational simulation mode")
            return False  # Force simulation mode in Replit
        
        # Try to import SDR libraries (may not work in Replit)
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
    """Main application entry point for Replit."""
    print("🛡️  WaveReconX Professional - Replit Edition")
    print("=" * 60)
    
    # Setup logging
    setup_logging()
    logging.info("Starting WaveReconX Professional (Replit Edition)")
    
    # Check if we're in Replit
    is_replit = check_replit_environment()
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    # Check hardware (will be limited in Replit)
    hardware_available = check_hardware()
    
    try:
        # Initialize and start the application
        app = WaveReconXEnhanced()
        
        # Set hardware status
        if not hardware_available:
            app.set_simulation_mode()
            print("🎓 Educational Mode: Using simulated data for learning purposes")
        
        print("✅ Application initialized successfully")
        print("🚀 Starting GUI...")
        
        # Start the main event loop
        app.run()
        
    except Exception as e:
        logging.error(f"Application startup failed: {e}")
        print(f"❌ Application startup failed: {e}")
        print("💡 Try running: pip install -r requirements-replit.txt")
        sys.exit(1)
    
    finally:
        logging.info("Application shutdown complete")

if __name__ == "__main__":
    main()
