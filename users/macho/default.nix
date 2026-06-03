{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
  imports = [
    ./configuration.nix
  ];

  name = "macho";

  extraGroups = [
  ];

  extraSpecialArgs = {
  };
}
