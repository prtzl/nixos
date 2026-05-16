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
    ]
    ++ lib.optionals (pillow.onHardware) [
      pipewire
      hardware
    ];
}
