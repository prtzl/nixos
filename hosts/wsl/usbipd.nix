{
  pkgs,
  ...
}:

let
  toBashArray = strings: "(${builtins.concatStringsSep " " (map (s: ''"${s}"'') strings)})";
  config_files = [ "/etc/usbipd/busids" ];

  usbipd-auto-attach-script = pkgs.writeShellApplication {
    name = "usbipd-auto-attach";
    runtimeInputs = [ ];
    text = ''
      CONFIG_FILES=${toBashArray config_files}
      USBIPD="/mnt/c/Program Files/usbipd-win/usbipd.exe"
      POLL_INTERVAL=5

      echo "usbipd auto-attach daemon started"

      while true; do
          for config_file in "''${CONFIG_FILES[@]}"; do
              if [[ ! -f "$config_file" ]]; then
                  echo "Skipping missing config: $config_file" >&2
                  continue
              fi

              mapfile -t busids < <(command grep -v '^\s*$' "$config_file")

              if [[ ''${#busids[@]} -eq 0 ]]; then
                  echo "No BUSIDs in $config_file, skipping"
                  continue
              fi

              echo "Checking BUSIDs: ''${busids[*]}"
              device_list="$("$USBIPD" list 2>&1)" || {
                  echo "Failed to query usbipd" >&2
                  continue
              }

              for busid in "''${busids[@]}"; do
                  line=$(echo "$device_list" | command grep -E "^''${busid}[[:space:]]" || true)

                  if [[ -z "$line" ]]; then
                      echo "Device $busid not present"
                      continue
                  fi

                  if echo "$line" | command grep -Eq "Shared"; then
                      echo "Device $busid is shared but not attached → attaching"
                      if "$USBIPD" attach --busid "$busid" --wsl 2>&1; then
                          echo "Device $busid attached successfully"
                      else
                          echo "Failed to attach device $busid" >&2
                      fi
                  else
                      echo "Device $busid: no action needed (already attached or not shared)"
                  fi
              done
          done

          sleep "$POLL_INTERVAL"
      done
    '';
  };
in
{
  systemd.services.usbipd-auto-attach = {
    description = "Auto-attach USB devices via usbipd";
    after = [ "default.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${usbipd-auto-attach-script}/bin/usbipd-auto-attach";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  systemd.tmpfiles.rules = [
    "d /etc/usbipd 0770 root users -"
    "f /etc/usbipd/busids 0660 root users -"
  ];
}
