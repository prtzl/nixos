{
  lib,
  pillow,
  ...
}:

{
  imports =
    with (lib.findModules ./units);
    [
      btop
      git
      home
      misc
      ranger
      shell
      tmux
      xdg
    ]
    ++ lib.optionals (pillow.hasGUI) [
      alacritty
      celluloid
      firefox
      gui
    ]
    ++ lib.optionals (pillow.onHardware) [
      solaar
      tio
    ];
}
