{
  lib,
  pillow,
  pkgs,
  ...
}:

{
  imports = with (lib.findModules ./.); [
    bash
    direnv
    fzf
    starship
    zsh
  ];

  home.packages =
    with pkgs;
    [
      bat
      eza
      fd
      fzf
      ripgrep
      tree
      xclip
      zsh-completions
    ]
    ++ lib.optionals (pillow.edition == "wsl") [ (import ./wslgit.nix { inherit pkgs; }) ];

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
