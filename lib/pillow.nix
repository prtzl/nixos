{
  inputs,
  lib,
  version,
}:

{
  makePillowArgs =
    {
      edition,
      host,
      hostPlatform,
      useDefaults ? true,
      hasGUI ? (edition == "workstation" || edition == "virtual"),
      settings ? { },
    }:
    assert edition == "workstation" || edition == "virtual" || edition == "wsl";
    {
      inherit
        edition
        hasGUI
        hostPlatform
        settings
        useDefaults
        ;
      # my attempt at forcing user to declare necessary host fields
      host = host // {
        name = host.name;
        interfaces = host.interfaces;
      };
      onHardware = (edition == "workstation" || edition == "virtual");
    };

  pillowSystem =
    {
      pillow,
      modules,
      specialArgs ? { },
    }:
    lib.nixosSystem {
      modules =
        modules
        ++ [
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.default
          inputs.nix-monitored.nixosModules.default
        ]
        ++ (lib.optionals pillow.useDefaults [
          inputs.nvimnix.nixosModules.default
          ../profiles/system
        ]);

      specialArgs = specialArgs // {
        inherit
          pillow
          inputs
          version
          ;
      };
    };

  pillowUser =
    pillow:
    {
      imports,
      name,
      initialHashedPassword ? null,
      extraGroups ? [ ],
      extraSpecialArgs ? { },
      # since this is for me I want sensible defaults for me
      personal ? true,
      privileged ? true,
    }:
    { config, lib, ... }:
    let
      homeImports =
        imports
        ++ (lib.optionals pillow.useDefaults [
          inputs.nvimnix.homeManagerModules.default
        ]);

      groupMapping = import ../lib/groupMapping.nix { inherit config lib; };

      # Sum together base groups and priviledged groups (with dynamic)
      allowedGroups = lib.unique (
        groupMapping.baseGroups
        ++ (if privileged then groupMapping.privilegedGroups else [ ])
        ++ groupMapping.dynamicGroups
      );

      allGroups = lib.unique (allowedGroups ++ extraGroups);
    in
    {
      config = {
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${name} = {
            imports = homeImports;
          };

          extraSpecialArgs = {
            inherit version;
            pillow = pillow // {
              inherit personal;
            };
            nixos_config = config;
          }
          // extraSpecialArgs;
        };

        users.users.${name} = {
          extraGroups = allGroups;
          initialHashedPassword = initialHashedPassword;
          isNormalUser = true;
        };
      };
    };
}
