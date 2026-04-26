{
  pkgs,
  ...
}:

let
  mybrightness = pkgs.writeShellApplication {
    name = "mybrightness";
    runtimeInputs = with pkgs; [
      brightnessctl
      dunst
    ];
    text = builtins.readFile ./brightness.sh;
  };
in
{
  environment.systemPackages = [ mybrightness ];
}
