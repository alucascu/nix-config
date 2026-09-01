{
  flake.modules.nixos.nvidia-telemetry = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # Samples dGPU health into the journal so that an Xid event has the
    # preceding minutes of temperature, power draw and PCIe link state on
    # record. Xid 79 ("GPU has fallen off the bus") leaves nothing behind
    # about the conditions that led to it -- this fills that gap.
    systemd.services.nvidia-telemetry = {
      description = "NVIDIA GPU health sampling";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service"];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "30s";
        Nice = 10;

        # Read-only sampling: no writes, no network, no privileges needed.
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateNetwork = true;
        NoNewPrivileges = true;
        RestrictAddressFamilies = ["AF_UNIX"];
        SystemCallFilter = ["@system-service"];
      };

      script = let
        # Xid 79 arrives with no warning; the last unrelated log line before the
        # Sep 1 freeze was 56s earlier. 5s keeps ~12 samples in that window.
        interval = 5;
        smi = lib.getExe' config.hardware.nvidia.package.bin "nvidia-smi";
        fields = lib.concatStringsSep "," [
          "temperature.gpu"
          "power.draw.instant"
          "utilization.gpu"
          "clocks.sm"
          "pcie.link.gen.current"
          "pcie.link.width.current"
          "clocks_throttle_reasons.active"
        ];
      in ''
        set -u

        # The nvidia driver binds exactly one device on this host; take the
        # first so the aspect stays free of a hardcoded PCI address.
        dev=""
        for d in /sys/bus/pci/drivers/nvidia/0000:*; do
          [ -e "$d" ] || continue
          dev="$(basename "$d")"
          break
        done

        if [ -z "$dev" ]; then
          echo "no PCI device bound to the nvidia driver; nothing to sample"
          exit 0
        fi

        echo "sampling $dev every ${toString interval}s"

        while :; do
          # sysfs is the ground truth for the link: it still answers after the
          # GPU stops responding to the driver, so a drop shows up here first.
          speed="$(cat "/sys/bus/pci/devices/$dev/current_link_speed" 2>/dev/null || echo '?')"
          width="$(cat "/sys/bus/pci/devices/$dev/current_link_width" 2>/dev/null || echo '?')"

          if out="$(timeout 5 ${smi} --query-gpu=${fields} \
                      --format=csv,noheader,nounits 2>&1 | tr -d '\n')"; then
            echo "link=''${speed}/x''${width} smi=''${out}"
          else
            echo "link=''${speed}/x''${width} smi=UNREACHABLE rc=$? out=''${out}"
          fi

          sleep ${toString interval}
        done
      '';
    };
  };
}
