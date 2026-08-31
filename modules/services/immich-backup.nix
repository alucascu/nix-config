{...}: {
  flake.modules.nixos.immich-backup = let
    common = {
      passwordFile = "/etc/restic-password";
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  in {
    services.restic.backups = {
      immich-atlas =
        common
        // {
          paths = ["/mnt/atlas/immich/"];
          repository = "/mnt/atlas/restic-repo";
        };

      immich-triton =
        common
        // {
          paths = ["/mnt/atlas/immich/"];
          repository = "/mnt/triton/restic-repo";
        };

      immich-proton =
        common
        // {
          paths = ["/mnt/atlas/immich"];
          repository = "rclone:proton:immich-backup";
          rcloneConfigFile = "/etc/rclone/rclone.conf";
        };
    };
  };
}
