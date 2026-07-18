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
    settings = {
      virtualisation.enable = false; # don't enable it on poor laptop
      containers.podman.enable = false; # don't enable it on poor laptop
      containers.docker.enable = false; # don't enable it on poor laptop
      hyprland = {
        bind = [
          {
            _args = [
              "XF86MonBrightnessUp"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"mybrightness up\")")
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86MonBrightnessDown"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"mybrightness down\")")
              {
                locked = true;
                repeating = true;
              }
            ];
          }
        ];
        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("blueman-applet")
                end
              '')
            ];
          }
        ];
      };
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
