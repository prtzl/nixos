{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [ tio ];
  xdg.configFile."tio/config".source = ./tiorc;
}
