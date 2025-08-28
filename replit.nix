{ pkgs }: {
  deps = [
    pkgs.python39
    pkgs.python39Packages.pip
    pkgs.python39Packages.virtualenv
    pkgs.cmake
    pkgs.build-essential
    pkgs.libusb1
    pkgs.libusb1.dev
    pkgs.pkg-config
    pkgs.git
    pkgs.wget
    pkgs.curl
  ];
}
