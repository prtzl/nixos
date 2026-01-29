# Stolen shit from: https://github.com/p3t33/nixos_flake/blob/master/modules/home-manager/tmux.nix

{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    gum
    zoxide
  ];

  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./tmux.conf) + "";
  };

  programs.sesh = {
    enable = true;
    package = pkgs.pkgs-unstable.sesh;
    icons = true;
    tmuxKey = "s";
    fzfPackage = config.programs.fzf.package;
    enableTmuxIntegration = true;
    # sessions should be per-device/instance at runtime. Privacy for work stuff
  };
}
