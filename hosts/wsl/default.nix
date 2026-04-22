{
  lib,
  ...
}:

lib.pillowSystem rec {
  pillow = lib.makePillowArgs {
    edition = "wsl";
    hostPlatform = "x86_64-linux";

    host = {
      name = "nixos";
      interfaces = [ "eth0" ];
      disks = [ "/" ];
    };
  };

  modules = (lib.findModulesList ./.) ++ [
    (import ../../users/nixos {
      inherit lib pillow;
    })
  ];

  specialArgs = {
  };
}
