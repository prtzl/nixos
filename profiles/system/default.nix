{
  lib,
  pillow,
  ...
}:

{
  # Apps and configs
  imports =
    with (lib.findModules ./units);
    [
      environment
      findre
      nixos
      update
      virtualization
    ]
    ++ lib.optionals (pillow.hasGUI) [
      firefox
      hyprland
    ]
    ++ lib.optionals (pillow.onHardware) [
      pipewire
      hardware
    ];
}
