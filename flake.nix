{
  description = "Asher's nix configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./modules/nix/flake-parts
        ./modules/system/settings/locale.nix
        ./modules/system/settings/nix.nix
        ./modules/services/pipewire.nix
        ./modules/programs/desktop-kde.nix
        ./modules/services/docker.nix
        ./modules/system/system-types/default.nix
        ./modules/users/alucascu.nix
        # home-manager modules
        ./modules/home/neovim
        ./modules/home/core.nix
        ./modules/home/git.nix
        ./modules/home/shell.nix
        ./modules/home/ssh.nix
        ./modules/home/terminal.nix
      ];

      systems = ["x86_64-linux"];

      flake = {
        nixosConfigurations.hades = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [./nixos/configuration.nix];
        };

        homeConfigurations."alucascu@hades" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs;};
          modules = [./home.nix];
        };
      };
    };
}
