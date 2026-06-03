{
  pkgs,
  inputs,
  pillow,
  ...
}:

let
  upstream-hyprland = inputs.hyprland.packages.${pillow.hostPlatform};
in
{
  programs.hyprland = {
    enable = true;
    package = upstream-hyprland.hyprland;
    portalPackage = upstream-hyprland.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Light weight and nice
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true; # save current session as default - handy
      load = true; # save current login username
    };
  };

  # needed by xfce apps to save config - yikes, well, at least not gnome
  programs.xfconf.enable = true;

  # Fixes electron apps in wayland, so I've read.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };

  # enable portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
