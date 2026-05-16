{
  config,
  myShell,
  ...
}:

{
  xdg.enable = true;

  programs.zsh = {
    enable = true;
    autocd = false;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = false; # do it manually
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = myShell.aliases;

    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "${config.xdg.stateHome}/zsh/.zsh_history";
      save = myShell.historyFileSize;
      size = myShell.historySize;
      share = true;
    };

    initContent = myShell.posixInit + ''
      autoload -U colors && colors      # colors
      autoload -U cominit colors zcalc  # theming

      # Tab completion
      autoload -Uz compinit
      compinit -d "${config.xdg.cacheHome}/zsh/.zcompdump"

      zstyle ':completion:*' menu select=1
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)--color=auto}"                      # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' rehash true                                                # automatically find new executables in path
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh"

      # Color man pages
      export LESS_TERMCAP_mb=$'\E[01;32m'
      export LESS_TERMCAP_md=$'\E[01;32m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;47;34m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[01;36m'
      export LESS=-R

      # completion
      zstyle :compinstall ${config.xdg.configHome}/zsh/.zshrc

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

      setopt rcexpandparam              # Array expension with parameters
      setopt nocheckjobs                # Don't warn about running processes when exiting
      setopt numericglobsort            # Sort filenames numerically when it makes sense
      setopt nobeep                     # No beep
    '';
  };
}
