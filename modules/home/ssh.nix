{lib, ...}: {
  flake.modules.homeManager.ssh = {
    lib,
    config,
    ...
  }: {
    options.myConfig.sshKeyName = lib.mkOption {
      type = lib.types.str;
      default = "id_ed25519";
      description = "SSH key basename under ~/.ssh/ used for all host identity files.";
    };

    config.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };

        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/${config.myConfig.sshKeyName}";
        };

        "codeberg" = {
          HostName = "codeberg.org";
          User = "git";
          IdentityFile = "~/.ssh/${config.myConfig.sshKeyName}";
        };

        "tantalus" = {
          HostName = "10.93.247.105";
          User = "alucascu";
        };
      };
    };
  };
}
