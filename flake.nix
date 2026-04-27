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

    lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lazyvim,
    ...
  } @ inputs: let
  in {
    # NixOS config entrypoint
    # Use 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      hades = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

	# Main NixOS config file
	modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configurations entrypoint
    # Available with 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "alucascu@hades" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

	extraSpecialArgs = {inherit inputs;};

	# Main home-manager configuration file
	modules = [ ./home-manager/home.nix ];
      };
    };
  };
}

