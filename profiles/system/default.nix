{
  lib,
  pillow,
  pkgs,
  ...
}:

{
  # Apps and configs
  imports =
    with (lib.findModules ./units);
    [
      env
      findre
      nixos
      update
    ]
    ++ lib.optionals (pillow.edition == "workstation") (
      with (lib.findModules ./units/virtualization);
      [
        container
        virtual
      ]
    )
    ++ lib.optionals (pillow.hasGUI) [
      firefox
      hyprland
      {
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        };
      }
    ]
    ++ lib.optionals (pillow.onHardware) [
      pipewire
      hardware
    ];
}
