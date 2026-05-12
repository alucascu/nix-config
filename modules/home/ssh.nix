{ lib, ... }: {
  flake.modules.homeManager.ssh = { lib, config, ... }: {
    options.myConfig.sshKeyName = lib.mkOption {
      type = lib.types.str;
      default = "id_ed25519";
      description = "SSH key basename under ~/.ssh/ used for all host identity files.";
    };

    config.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
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
          host = "github.com";
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/${config.myConfig.sshKeyName}";
        };

        "codeberg" = {
          host = "codeberg.org";
          hostname = "codeberg.org";
          user = "git";
          identityFile = "~/.ssh/${config.myConfig.sshKeyName}";
        };
      };
    };
  };
}
