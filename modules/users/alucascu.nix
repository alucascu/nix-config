{inputs, ...}: {
  flake.modules.nixos.alucascu = {pkgs, ...}: {
    home-manager.backupFileExtension = "bak";

    users.users.alucascu = {
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel" "networkmanager" "docker"];
      openssh.authorizedKeys.keys = [];
    };

    home-manager.users.alucascu.imports = [
      inputs.self.modules.homeManager.alucascu
    ];
  };

  flake.modules.homeManager.alucascu = {
    imports = with inputs.self.modules.homeManager; [
      core
      shell
      git
      neovim
      ssh
      terminal
      gnupg
      work
      globalprotect
      browser
    ];
  };
}
