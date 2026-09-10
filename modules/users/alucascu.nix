{inputs, ...}: {
  flake.modules.nixos.alucascu = {pkgs, ...}: {
    home-manager.backupFileExtension = "bak";

    users.users.alucascu = {
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel" "networkmanager" "docker"];
      # Public halves of the two user keys already declared as agenix
      # recipients in secrets/secrets.nix; kept in sync by hand.
      openssh.authorizedKeys.keys = [
        # alucascu@hades
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjientAZiNuoiwFV7bMdkNZB0j5qM+TsHGKwG2KXbO5 alucascu@hades"
        # alucascu@odysseus
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVLgoxrHCSzVI2X1hgL/cN+VYot2TA3N+cTe/9oL3os alucascu@proton.me"
      ];
    };

    home-manager.users.alucascu.imports = [
      inputs.self.modules.homeManager.alucascu
    ];

    programs.nh.flake = "/home/alucascu/nixConfig";
  };

  flake.modules.homeManager.alucascu = {
    imports = with inputs.self.modules.homeManager; [
      core
      shell
      git
      neovim
      ssh
      gnupg
      zellij
      uv-tools
      nix-tools
    ];

    home = {
      username = "alucascu";
      homeDirectory = "/home/alucascu";
    };
  };
}
