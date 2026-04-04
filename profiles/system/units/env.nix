{
  pillow,
  pkgs,
  ...
}:

{
  users.defaultUserShell = pkgs.zsh;

  environment = {
    shells = with pkgs; [
      bashInteractive
      zsh
    ];
    variables = {
      EDITOR = "vim";
    };
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    # philosohpy: only those that I could see using on a bare (shell) system
    # Also not opinionated - like everyone is using rg, fd, etc ...
    # Save the rest for home defaults or per-user
    systemPackages =
      with pkgs;
      [
        bat # replacement for cat
        btop # system info graphs, usage, etc. Modern top
        eza # replacement for exa, replacement for ls
        fastfetch # replacement for neofetch :'(
        fd # modern find
        file # shows file info (standard linux utility)
        fx # json  viewer
        git # yeah
        jq # json processor
        nmap # sniff ports
        parted # partitions
        ripgrep # modern grep
        sd # modern sed (handles escapes like rg automatically)
        tldr # man, but faster for finding usage
        vim # backup, always nice
        wget # get web, he he
      ]
      ++ lib.optionals (pillow.onHardware) [
        hwinfo # self explanatory
        pciutils # info on pci devices
        smartmontools # disk checks
        udiskie # automounts using udisks2
        usbutils # info on usb devices
      ];
  };

  # As on top - only what a bare system would really like to have
  programs = {
    usbtop.enable = pillow.onHardware;
    zsh.enable = true;
    nvimnix.enable = true; # my nvim, always use
  };

  services = {
    fwupd.enable = pillow.onHardware;
    geoclue2.enable = true; # required for localtimed (fails if not found)
    localtimed.enable = true; # time and datre control (otherwise I'm off :O
    printing.enable = pillow.onHardware; # printing drivers
    udisks2.enable = pillow.onHardware; # daemon for mounting storage devices (usbs and such)
    usbmuxd.enable = pillow.onHardware; # usb info
  };

  location.provider = "geoclue2"; # required for geoclue2 service, which ...

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocales = "all";
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    fontDir.enable = true;
    packages = with pkgs; [
      fira
      fira-code
      fira-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-color-emoji
    ];
  };
}
