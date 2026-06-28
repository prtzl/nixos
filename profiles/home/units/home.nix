{
  pillow,
  pkgs,
  pkgs-unfree,
  version,
  ...
}:

{
  home.stateVersion = version;
  home.preferXdgDirectories = true;

  home.packages =
    let
      # One on unstable version (6.11.6.183) has issue downloading the resource. Go for newest.
      _my-enpass =
        let
          baseUrl = "https://apt.enpass.io";
          path = "pool/main/e/enpass/enpass_6.11.13.1957_amd64.deb";
          url = "${baseUrl}/${path}";
          version = "6.11.13.1957";
          sha256 = "2d8c90643851591aff41057b380a7e87bb839bf5c5aa0ca1456144e9996c902a";
        in
        pkgs.enpass.overrideAttrs (old: {
          inherit version;
          src = builtins.fetchurl {
            inherit sha256 url;
          };
        });
    in
    with pkgs;
    [
      duf # modern df with colors :D
      dysk # disk usage
      ffmpeg-full # yes
    ]
    ++ lib.optionals (pillow.hasGUI) [
      # Web
      ungoogled-chromium
      transmission_4-gtk

      # Utility
      pkgs-unfree.enpass # my-enpass
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
      thunar
      thunar-archive-plugin
      tumbler
    ];
}
