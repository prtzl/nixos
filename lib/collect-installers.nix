{ lib, inputs }:

let
  hosts = builtins.filter (n: (builtins.readDir ./../hosts)."${n}" == "directory") (
    builtins.attrNames (builtins.readDir ./../hosts)
  );

  installerModule = inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";

  mkInstaller =
    host:
    import (./../hosts + "/${host}") {
      inherit lib inputs;
      extraModules = [ installerModule ];
    };

  installers = lib.genAttrs hosts mkInstaller;

  isos = lib.mapAttrs' (name: cfg: {
    name = "${name}-installer";
    value = cfg.config.system.build.isoImage;
  }) installers;

in
isos
