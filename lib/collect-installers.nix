{ lib, inputs }:

let
  hosts = builtins.filter (n: (builtins.readDir ./../hosts)."${n}" == "directory") (
    builtins.attrNames (builtins.readDir ./../hosts)
  );

  installerModules = [
    (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
    (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  mkInstaller =
    host:
    import (./../hosts + "/${host}") {
      inherit lib inputs;
      extraModules = installerModules ++ [
        ({
          isoImage.isoName = "nixos-installer-${host}.iso";
          isoImage.makeEfiBootable = true;
          isoImage.makeUsbBootable = true;
          isoImage.appendToMenuLabel = " live";
        })
      ];
    };

  installers = lib.genAttrs hosts mkInstaller;

  isos = lib.mapAttrs' (name: cfg: {
    name = "${name}-installer";
    value = cfg.config.system.build.isoImage;
  }) installers;

in
isos
