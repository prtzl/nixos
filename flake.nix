{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvimnix.url = "github:prtzl/nvimnix";
    # nvimnix.url = "/home/matej/projects/git/nvimnix";
    jlink = {
      url = "github:prtzl/jlink-nix";
      # url = "/home/matej/projects/git/jlink-nix/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ flake-parts, disko, ... }:
    let
      version = "25.11";
      lib = import ./lib { inherit inputs version; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosConfigurations = lib.collectHosts;
      };

      systems = builtins.attrNames disko.packages;

      perSystem =
        { pkgs, system, ... }:
        {
          packages.disko = disko.packages.${system}.default;
        };
    };
}
