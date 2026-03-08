{ pkgs, ... }:

let
  celluloid = pkgs.writeShellApplication {
    name = "celluloid";
    runtimeInputs = with pkgs; [
      pkgs.celluloid
      jq
    ];
    text = builtins.readFile ./celluloid_hypr.sh;
  };
in
{
  home.packages = [ celluloid ];

  home.file.".local/share/applications/celluloid.desktop".source =
    "${pkgs.celluloid}/share/applications/io.github.celluloid_player.Celluloid.desktop";
}
