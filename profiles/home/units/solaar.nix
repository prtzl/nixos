{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.solaar-custom;
in
{
  options.services.solaar-custom = {
    enable = lib.mkEnableOption "Solaar daemon (user service)";
    window = lib.mkOption {
      type = lib.types.str;
      default = "hide";
      description = ''
        Solaar window mode
              {show,hide,only}
              start with window showing / hidden / only (no tray icon)'';
    };
    battery = lib.mkOption {
      type = lib.types.str;
      default = "regular";
      description = ''
        Solaar battery icon style
              {regular,symbolic,solaar} 
              prefer regular battery / symbolic battery / solaar icons'';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.solaar ];

    systemd.user.services.solaar = {
      Unit = {
        Description = "Solaar (Logitech device manager)";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.solaar}/bin/solaar --window=${cfg.window} --battery=${cfg.battery}";
        Restart = "on-failure";
        Type = "simple";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  # enable itself as well
  imports = [
    {
      services.solaar-custom.enable = true;
    }
  ];
}
