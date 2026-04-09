{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
  imports = [
    ../../profiles/home
  ];

  name = "nixos";

  extraGroups = [
    "usb"
    "dialout"
  ];

  extraSpecialArgs = {
  };
}
