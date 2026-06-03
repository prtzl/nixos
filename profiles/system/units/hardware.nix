{
  lib,
  pillow,
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  systemd.network.wait-online.extraArgs = map (
    interface: "--interface=${interface}"
  ) pillow.host.interfaces;

  networking = {
    enableIPv6 = false;
    firewall.enable = true;
    hostName = pillow.host.name;
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  services.udev = {
    packages = with pkgs; [
      stlink
      tio
    ];
    extraRules = ''
      # Add all USB devices to usb group -> don't forget with your user
      KERNEL=="*", SUBSYSTEMS=="usb", MODE="0664", GROUP="usb"

      # RS232 devucesm yee
      SUBSYSTEMS=="usb", KERNEL=="ttyUSB[0-9]*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="sensors/ftdi_%s{serial}", GROUP="dialout"

      # Somehow added jlink file to udev does not get picked up :/
    '';
  };
}
