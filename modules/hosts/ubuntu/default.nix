{inputs, ...}: {
  # Standalone home-manager config for Nix-on-Ubuntu (not NixOS).
  # Apply with: home-manager switch --flake .#ubuntu
  flake.modules.homeManager.ubuntu = {lib, ...}: {
    imports = with inputs.self.modules.homeManager; [
      core
      shell
      git
      neovim
      ssh
      terminal
      gnupg
    ];

    # core.nix hardcodes alucascu; override for the ubuntu user.
    home = {
      username = lib.mkForce "ubuntu";
      homeDirectory = lib.mkForce "/home/ubuntu";
      sessionPath = lib.mkForce ["/home/ubuntu/.local/bin"];
    };

    programs.home-manager.enable = true;
  };

  flake.homeConfigurations = inputs.self.lib.mkHome "x86_64-linux" "ubuntu";
}
