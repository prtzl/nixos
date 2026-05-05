{
  config,
  myShell,
  pillow,
  ...
}:

{
  # Let's configure bash with even starship, fzf, and direnv when needed
  # zsh seems to have features I like, but I can still have good
  # ux when bash is required for compatability (nix develop)
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = "${config.xdg.configHome}/.bash_history";
    historySize = myShell.historySize;
    historyFileSize = myShell.historyFileSize;

    shellAliases = myShell.aliases;

    initExtra = myShell.posixInit + "";
  };
}
