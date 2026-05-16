{
  lib,
  pkgs,
  inputs,
  pillow,
  ...
}:

let
  upstream-hyprland-inputs = inputs.hyprland;
  upstream-hyprland-hyprcursor =
    upstream-hyprland-inputs.inputs.hyprcursor.packages.${pillow.hostPlatform}.default;
in
{
  home.packages =
    with pkgs;
    [
      # hyprcursor # I guess this has to come separately
      wl-clipboard # clipboard (why is this additional, like  what?)
      networkmanagerapplet # brings network manager applet functionality
      grimblast # screenshot utility
    ]
    ++ [ upstream-hyprland-hyprcursor ];

  # The jummy thing about this is that now as a service it reloads on configurations change automatically!
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # match nixos installed
    portalPackage = null; # match nixos installe
    systemd.enable = true;
    # main hyprland config in native format
    # extraConfig = builtins.readFile ./hyprland.conf;
    extraConfig = builtins.readFile ./hyprland.lua;
    # hyprland config in nix format - programmable part
    # settings =
    #   let
    #     defaultSettings = {
    #       monitor = lib.mkDefault [ ",preferred,auto,1" ];
    #     };
    #     userSettings = pillow.settings;
    #     hyprlandSettings = if (userSettings ? hyprland) then userSettings.hyprland else { };
    #   in
    #   defaultSettings // hyprlandSettings;
  };

  # Background setting app
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      preload = "${./doom.jpg}";
      wallpaper = ",${./doom.jpg}";
    };
  };

  # Screen color without affecting screenshot/screenrecording SW
  # One of the two following entries (units or restart) makes this work now. There is a race condition that makes the wlsunset start before the wayland is really up
  systemd.user.services.wlsunset.Unit.After = [
    "hyprland-session.target"
    "hyprland.service"
  ];
  systemd.user.services.wlsunset.Service.Restart = "on-failure";
  services.wlsunset = {
    enable = true;
    temperature.day = 4001;
    temperature.night = 4000;
    latitude = 0;
    longitude = 0;
  };
}
