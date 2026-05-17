{
  lib,
  extraModules ? [ ],
  ...
}:

let
  extraModulesLocal = with lib.findModules ../../profiles/system/units/virtualization; [ container ];
in
lib.pillowSystem rec {
  pillow = lib.makePillowArgs {
    edition = "wsl";
    hostPlatform = "x86_64-linux";

    host = {
      name = "wsl";
      interfaces = [ "eth0" ];
      disks = [ "/" ];
    };

    settings.container.podman.enable = true;
  };

  modules =
    extraModules
    ++ extraModulesLocal
    ++ (lib.findModulesList ./.)
    ++ [
      (import ../../users/nixos {
        inherit lib pillow;
      })
    ];

  specialArgs = {
  };
}
