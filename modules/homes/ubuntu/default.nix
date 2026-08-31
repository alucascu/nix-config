{inputs, ...}: {
  # Standalone home-manager config for Nix-on-Ubuntu (not NixOS).
  # Apply with: home-manager switch --flake .#ubuntu
  flake.modules.homeManager.ubuntu = {
    imports = with inputs.self.modules.homeManager; [
      core
      shell
      git
      neovim
      ssh
      terminal
      gnupg
    ];

    home = {
      username = "ubuntu";
      homeDirectory = "/home/ubuntu";
    };
  };

  flake.homeConfigurations = inputs.self.lib.mkHome "x86_64-linux" "ubuntu";
}
