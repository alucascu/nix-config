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
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

        "github" = {
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
          Host = "tantalus";
          HostName = "10.93.247.105";
          User = "alucascu";
        };
      };
    };
  };
}
