{
  config,
  myShell,
  pillow,
  ...
}:

{
  xdg.enable = true; # just to make sure, since it's used here

  # if it doesn't exist, then compinit will put it into wherever .zshrc is and all links to .cache/zsh will be wrong
  # then compinit re-builds it every time and never uses it ... huh
  home.activation.createZshCacheDir = ''
    mkdir -p ${config.xdg.cacheHome}/zsh
  '';
  # same story
  home.activation.createZshStateDir = ''
    mkdir -p ${config.xdg.stateHome}/zsh
  '';

  programs.zsh = {
    enable = true;
    autocd = false;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = false; # do it myself

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

    initContent =
      myShell.posixInit
      + ''
        autoload -U colors
        colors

        # Tab completion
        autoload -Uz compinit
        compinit -C -u -d "${config.xdg.cacheHome}/zsh/.zcompdump"

        zstyle ':completion:*' menu select=1
        zstyle ':completion:*' rehash true                                                # automatically find new executables in path
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh"

        # first try the usual completion and, if nothing matches, to try a case-insensitive completion
        # also try to complete partial words you’ve typed
        zstyle ':completion:*' matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
        # completing for an option
        zstyle ':completion:*' complete-options true
        # // is expanded to /
        zstyle ':completion:*' squeeze-slashes true
        # colors :D
        zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}

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
      ''
      + (if pillow.edition == "wsl" then "compdef wslgit=git" else "");
  };
}
