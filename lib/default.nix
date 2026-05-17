{
  inputs,
  version,
}:

inputs.nixpkgs.lib.extend (
  final: prev:
  let
    pillow = import ./pillow.nix {
      lib = final;
      inherit
        version
        inputs
        ;
    };
    collectHosts = import ./collect-hosts.nix {
      lib = final;
      inherit inputs;
    };
    collectInstallers = import ./collect-installers.nix {
      lib = final;
      inherit inputs;
    };
    utils = import ./utils.nix { lib = final; };
  in
  pillow // { inherit collectHosts collectInstallers; } // utils
)
