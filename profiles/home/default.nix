{
  config,
  lib,
  pillow,
  pkgs,
  version,
  ...
}:

{
  imports =
    with (lib.findModules ./units);
    [
      btop
      git
      ranger
      shell
      tmux
    ]
    ++ lib.optionals (pillow.hasGUI) [
      alacritty
      celluloid
      firefox
      gui
    ]
    ++ lib.optionals (pillow.onHardware) [
      tio
    ];

  home.stateVersion = version;
  # programs.nvimnix.enable = true; # my nvim always use

  programs.vim = {
    enable = true;
    extraConfig = ''
      set viminfo=%,'1000,<500,s100,h,n~/.local/state/vim/viminfo
    '';
  };
  home.activation.createVimHistoryDir = ''
    mkdir -p ${config.xdg.stateHome}/vim
  '';

  home.packages =
    let
      # One on unstable version (6.11.6.183) has issue downloading the resource. Go for newest.
      my-enpass =
        let
          baseUrl = "https://apt.enpass.io";
          path = "pool/main/e/enpass/enpass_6.11.13.1957_amd64.deb";
          url = "${baseUrl}/${path}";
          version = "6.11.13.1957";
          sha256 = "2d8c90643851591aff41057b380a7e87bb839bf5c5aa0ca1456144e9996c902a";
        in
        pkgs.pkgs-unstable.enpass.overrideAttrs (old: {
          inherit version;
          src = builtins.fetchurl {
            inherit sha256 url;
          };
        });
    in
    with pkgs;
    [
      dysk
      ffmpeg-full # yes
    ]
    ++ lib.optionals (pillow.hasGUI) [
      # Web
      ungoogled-chromium
      transmission_4-gtk

      # Utility
      pkgs-unstable.enpass # my-enpass
      qalculate-gtk # calculator fyi
      gnome-disk-utility

      # Communication
      signal-desktop

      # media/creation
      audacity
      libreoffice
      gimp
      inkscape
      gthumb # image viewer

      # file explorer
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.tumbler

      # wine
      wineWowPackages.waylandFull
      winetricks
    ]
    ++ lib.optionals pillow.onHardware [
      monitorets # GUI for temperature sensors
    ];

  # python: Don't put python dotshit into home
  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
  };
  home.activation.createPythonHistoryDir = ''
    mkdir -p ${config.xdg.stateHome}/python
  '';
}
