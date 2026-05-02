{
  pkgs,
  ...
}:

{
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    fontDir.enable = true;
    packages =
      with pkgs;
      [
        noto-fonts
        noto-fonts-color-emoji
      ]
      ++ (with nerd-fonts; [
        fira-code
        noto
      ]);
  };
}
