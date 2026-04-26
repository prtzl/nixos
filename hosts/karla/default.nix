{
  lib,
  ...
}:

lib.pillowSystem rec {
  pillow = lib.makePillowArgs {
    edition = "workstation";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = {
      name = "karla";
      interfaces = [
        "wlp61s0"
        "enp0s31f6"
      ];
      disks = [ "/" ];
      temp_probes = [
        {
          path = "/dev/cpu_temp";
          icon = "";
          color = "#43a047";
        }
      ];
      batteries = [
        "BAT0"
      ];
    };
    settings.hyprland = {
      bind = [
        ", XF86MonBrightnessUp, exec, mybrightness up"
        ", XF86MonBrightnessDown, exec, mybrightness down"
      ];
    };
  };

  modules = (lib.findModulesList ./.) ++ [
    (import ../../users/matej {
      inherit lib pillow;
    })
  ];

  specialArgs = {
  };
}
