{
  pillow,
  pkgs,
  ...
}:

{
  imports = [ <nixos-wsl/modules> ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    interop.register = false;
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
      };
    };

    jlink.enable = true;

    udev = {
      enable = true;
      packages = with pkgs; [
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
  };

  environment.systemPackages = with pkgs; [
    kmod
    usbutils
  ];
}
