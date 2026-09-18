{
  flake.modules.nixos.fan-curve = {lib, ...}: let
    # Radiator fan pair.
    # pwm7 is the aio pump header it's always at 255
    curves = {
      "1" = [[30 51] [45 77] [60 128] [75 191] [85 255]];
      "2" = [[30 51] [45 77] [60 128] [75 191] [85 255]];
    };

    stepUpTime = 100;
    stepDownTime = 3000;

    channel = ch: points:
      lib.concatStringsSep "\n" (
        lib.imap1 (
          i: point: let
            temp = toString (builtins.elemAt point 0 * 1000);
            duty = toString (builtins.elemAt point 1);
            n = toString i;
          in ''
            set_attr pwm${ch}_auto_point${n}_temp ${temp}
            set_attr pwm${ch}_auto_point${n}_pwm ${duty}''
        )
        points
        ++ [
          ''

            set_attr pwm${ch}_step_up_time ${toString stepUpTime}
            set_attr pwm${ch}_step_down_time ${toString stepDownTime}

            set_attr pwm${ch}_enable 5''
        ]
      );
  in {
    boot.kernelModules = ["nct6775"];

    systemd.services.fan-curve = {
      description = "Program NCT6799D Smart Fan IV curves";

      wantedBy = ["multi-user.target" "post-resume.target"];
      after = ["systemd-modules-load.service" "post-resume.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateNetwork = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        RestrictAddressFamilies = ["AF_UNIX"];
        SystemCallFilter = ["@system-service"];
      };

      script = ''
        set -eu

        hwmon=""
        for d in /sys/devices/platform/nct6775.*/hwmon/hwmon*; do
          [ -d "$d" ] || continue
          hwmon="$d"
          break
        done

        if [ -z "$hwmon" ]; then
          echo "no nct6775 hwmon node found; is the module loaded?" >&2
          exit 1
        fi

        echo "programming $(cat "$hwmon/name") at $hwmon"

        set_attr() {
          if [ ! -w "$hwmon/$1" ]; then
            echo "  $1: absent or read-only, skipped" >&2
            return 0
          fi
          echo "$2" > "$hwmon/$1"
        }

        ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList channel curves)}
      '';
    };
  };
}
