{
  pkgs,
  ...
}:

let
  findre = pkgs.writeShellApplication {
    name = "findre";
    runtimeInputs = with pkgs; [
      fd
      ripgrep
    ];
    text = ''
      pattern=''${1:-""}
      fd "$pattern" "''${@:2}" --color always | rg --color=always --passthrough "''$pattern"
    '';
  };
in
{
  environment.systemPackages = [ findre ];
}
