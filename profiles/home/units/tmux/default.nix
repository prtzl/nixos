{
  config,
  pkgs,
  ...
}:

{
  programs.zoxide = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./tmux.conf) + ''
      unbind-key s
      bind-key "S" choose-session # move default session switcher

      bind-key "s" run-shell "sesh connect \"$(
        sesh list --icons | fzf --tmux 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list --icons -t)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list --icons -c)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list --icons -z)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:50%' \
          --preview 'sesh preview {}' \
          -- --ansi
      )\""
    '';
  };

  programs.sesh = {
    enable = true;
    package = pkgs.pkgs-unstable.sesh.overrideAttrs (old: rec {
      version = "2.25.0";
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "sesh";
        rev = "v${version}";
        hash = "sha256-azs1tf9eR4MVSdjMdd3U/xdPAANn1Kyamf0TwFrBSTU=";
      };
    });
    icons = false;
    tmuxKey = null; # I'll do this, thank you
    fzfPackage = config.programs.fzf.package;
    enableTmuxIntegration = false; # customize my tmux prompt upstairs
    settings = {
      import = [ "~/.local/share/sesh/sesh-local.toml" ]; # this has to exist!
    };
  };
}
