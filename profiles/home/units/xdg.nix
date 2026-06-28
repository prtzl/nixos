{
  ...
}:

{
  xdg = {
    enable = true;

    # dataHome = "~/.local/share";
    # stateHome = "~/.local/state";
    # cacheHome = "~/.cache";
    # configHome = "~/.config";

    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;

      defaultApplications = {
        # "application/pdf" = "org.pwmt.zathura-pdf.desktop";
      };
    };

    # systemDirs = {
    #   data = [
    #     "/usr/share"
    #     "/usr/local/share"
    #   ];
    #
    #   config = [ "/etc/xdg" ];
    # };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

}
