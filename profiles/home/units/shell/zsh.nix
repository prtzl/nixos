{
  config,
  myShell,
  pillow,
  ...
}:

{
  xdg.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = myShell.aliases // (if (pillow.edition == "wsl") then { git = "wslgit"; } else { });

    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "$HOME/.config/zsh/.zsh_history";
      save = myShell.historyFileSize;
      size = myShell.historySize;
      share = true;
    };

    initContent = myShell.posixInit + ''
      # Nice completion with menus 
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      _comp_options+=(globdots)

      # fix ls alias not autocompleting since it's aliased
      compdef eza=ls

      # F$cked keys, give them back
      bindkey "^[[3~" delete-char
      bindkey "^[[3;5~" delete-char
      bindkey '^H' backward-kill-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '\e[11~' "urxvt &\n"

      # enable vim mode (default is insert, esc gets you to normal)
      bindkey -v
    '';
  };
}
