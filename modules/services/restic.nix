{inputs, ...}: {
  flake.modules.nixos.restic = {config, ...}: {
    age.secrets.restic-env.file = "${inputs.self}/secrets/restic-env.age";

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
      # Contains RESTIC_PASSWORD and any repo credentials. Create
      # secrets/restic-env.age and list it in secrets/secrets.nix before
      # importing this aspect on a host.
      environmentFile = config.age.secrets.restic-env.path;
    };
  };
}
