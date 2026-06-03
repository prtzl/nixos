{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
  imports = [
    ./configuration.nix
  ];

  name = "nacho";
  privileged = false;

  extraGroups = [ ];

  extraSpecialArgs = {
  };
}
