#!/usr/bin/env python3
"""
Setup script for WaveReconX Professional
Enhanced RF Spectrum Analysis Tool
"""

from setuptools import setup, find_packages
from pathlib import Path

# Read the README file
this_directory = Path(__file__).parent
long_description = (this_directory / "README.md").read_text()

# Read requirements
requirements_file = this_directory / "requirements" / "requirements.txt"
requirements = []
if requirements_file.exists():
    with open(requirements_file, 'r') as f:
        requirements = [line.strip() for line in f if line.strip() and not line.startswith('#')]

setup(
    name="wave-recon-x",
    version="2.0.0",
    author="WaveReconX Team",
    author_email="team@wave-recon-x.com",
    description="Enhanced RF Spectrum Analysis Tool",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/wave-recon-x/wave-recon-x",
    project_urls={
        "Bug Tracker": "https://github.com/wave-recon-x/wave-recon-x/issues",
        "Documentation": "https://wave-recon-x.readthedocs.io/",
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Communications :: Ham Radio",
        "Topic :: Scientific/Engineering :: Information Analysis",
        "Topic :: Security",
        "Topic :: System :: Hardware",
    ],
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    python_requires=">=3.8",
    install_requires=requirements,
    extras_require={
        "dev": [
            "pytest>=6.2.5",
            "pytest-cov>=2.12.0",
            "black>=21.5b2",
            "flake8>=3.9.0",
            "mypy>=0.812",
        ],
        "docs": [
            "sphinx>=4.0.0",
            "sphinx-rtd-theme>=0.5.2",
        ],
        "full": [
            "matplotlib>=3.4.0",
            "plotly>=5.0.0",
            "seaborn>=0.11.0",
            "scikit-learn>=1.0.0",
            "tensorflow>=2.6.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "wave-recon-x=main:main",
        ],
    },
    include_package_data=True,
    package_data={
        "": ["*.json", "*.yaml", "*.yml"],
    },
    keywords="rf, spectrum, analysis, sdr, gsm, lte, umts, 5g, security, monitoring",
    platforms=["Linux", "Unix"],
    license="MIT",
    zip_safe=False,
)
