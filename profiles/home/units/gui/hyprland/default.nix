{
  lib,
  pillow,
  pkgs,
  ...
}:

# INFO: use pkgs since that's overriden by hyprland upstream flake along with all of it's related packages
# Therefore hyprcursor, for example, will come from there and will thus depend on hyprland from upstream instead
# of using one from nixpkgs.
{
  home.packages = with pkgs; [
    hyprcursor # I guess this has to come separately
    wl-clipboard # clipboard (why is this additional, like  what?)
    networkmanagerapplet # brings network manager applet functionality
    grimblast # screenshot utility
  ];

  # The jummy thing about this is that now as a service it reloads on configurations change automatically!
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # match nixos installed
    portalPackage = null; # match nixos installe
    systemd.enable = true;
    configType = "lua";
    # main hyprland config in native format
    # extraConfig = builtins.readFile ./hyprland.conf;
    extraConfig = builtins.readFile ./hyprland.lua;
    # hyprland config in nix format - programmable part
    settings =
      let
        defaultSettings = {
          monitor = lib.mkDefault {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "1";
          };
        };
        userSettings = pillow.settings;
        hyprlandSettings = if (userSettings ? hyprland) then userSettings.hyprland else { };
      in
      defaultSettings // hyprlandSettings;
  };

  # Background setting app
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = { };
  };
  # INFO: exporter does not put monitor at the top, so hyprpaper complains
  home.file.".config/hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor=
      path=${./doom.jpg}
      fit_mode=cover
    }
  '';

  # Screen color without affecting screenshot/screenrecording SW
  # One of the two following entries (units or restart) makes this work now. There is a race condition that makes the wlsunset start before the wayland is really up
  systemd.user.services.wlsunset.Unit = {
    After = lib.mkForce [ "hyprland-session.target" ];
    Wants = [ "hyprland-session.target" ];

    ConditionEnvironment = lib.mkForce "";
  };
  services.wlsunset = {
    package = pkgs.wlsunset;
    enable = true;
    temperature.day = 4001;
    temperature.night = 4000;
    latitude = 0;
    longitude = 0;
  };
}
