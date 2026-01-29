# Stolen shit from: https://github.com/p3t33/nixos_flake/blob/master/modules/home-manager/tmux.nix

{
  # config,
  pkgs,
  ...
}:

let
  seshKey = "s";
in
{
  home.packages = with pkgs.pkgs-unstable; [
    sesh
    zoxide
  ];

  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./tmux.conf) + ''
      bind-key "${seshKey}" run-shell "sesh connect \"$(
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
          --preview-window 'right:75%' \
          --preview 'sesh preview {}' \
          -- --ansi
      )\""
    '';
  };

  # THis idiot adds file in ~/.config/sesh/sesh.toml EMPTY
  # SO I cannot add sessions per-system there. Ughhhh
  # programs.sesh = {
  #   enable = true;
  #   package = pkgs.pkgs-unstable.sesh;
  #   icons = true;
  #   tmuxKey = seshKey;
  #   fzfPackage = config.programs.fzf.package;
  #   enableTmuxIntegration = false; # customize my tmux prompt upstairs
  #   # sessions should be per-device/instance at runtime. Privacy for work stuff
  # };
}
