{...}: {
  flake.modules.nixos.restic = {
    services.restic.backups.home = {
      repository = "/run/media/alucascu/Extreme SSD/restic/";
      paths = ["/home/alucascu"];
      exclude = [
        "/home/alucascu/.cache"
        "/home/alucascu/.local/share/containers"
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
      # Reference a file containing RESTIC_PASSWORD and any repo credentials
      environmentFile = "/run/secrets/restic-env";
    };
  };
}
