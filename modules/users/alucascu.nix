{inputs, ...}: {
  flake.modules = {
    nixos.alucascu = {
      users.users.alucascu = {
        initialPassword = "correcthorsebatterystaple";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "docker"];
        openssh.authorizedKeys.keys = [];
      };

      home-manager.users.alucascu.imports = [
        inputs.self.modules.homeManager.alucascu
      ];
    };

    homeManager.alucascu = {
      imports = with inputs.self.modules.homeManager; [
        core
        shell
        git
        neovim
        ssh
        terminal
      ];
    };
  };
}
