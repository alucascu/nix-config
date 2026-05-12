{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
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
          identityFile = "/home/alucascu/.ssh/odysseus";
        };

        "codeberg" = {
          host = "codeberg.org";
          hostname = "codeberg.org";
          user = "git";
          identityFile = "/home/alucascu/.ssh/odysseus";
        };
      };
    };
  };
}
