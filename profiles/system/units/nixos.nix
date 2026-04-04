{
  inputs,
  pillow,
  version,
  ...
}:

{
  nix = {
    monitored = {
      enable = true;
      notify = false;
    };
    registry = {
      # nixpkgs (default) == stable branch (my default)
      stable.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
      master.to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
      };
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      binary-caches-parallel-connections = 50
      preallocate-contents = false
    '';
  };

  system.stateVersion = version;

  nixpkgs = {
    hostPlatform = "${pillow.hostPlatform}";
    overlays = [
      (final: prev: {
        pkgs-unfree = import inputs.nixpkgs {
          localSystem = final.stdenv.buildPlatform;
          hostPlatform = final.stdenv.hostPlatform;
          config.allowUnfree = true;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          localSystem = final.stdenv.buildPlatform;
          hostPlatform = final.stdenv.hostPlatform;
          config.allowUnfree = true;
        };
      })
    ];
  };

  # Create group where all members (privileged) have access to /etc/nixos where the config SHOULD be placed
  users.groups.nixos-editors = { };
  systemd.tmpfiles.rules = [
    "d /etc/nixos 0770 root nixos-editors -"
  ];
}
