{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
  imports = [
    ./configuration.nix
  ];

  name = "matej";

  extraGroups = [
    "usb"
  ];

  extraSpecialArgs = {
  };
}
