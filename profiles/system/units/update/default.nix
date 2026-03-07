{
  pkgs,
  ...
}:

let
  nixos-update = pkgs.writeShellApplication {
    name = "nixos-update";
    runtimeInputs = [ pkgs.nvd ];
    text = ''
      exec bash ${./update.sh} "nixos" "$@"
    '';
  };
in
{
  environment.systemPackages = [ nixos-update ];
}
