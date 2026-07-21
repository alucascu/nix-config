{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  systems = ["x86_64-linux"];

  flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit (inputs.nixpkgs) lib;
          modulesPath = "${inputs.nixpkgs}/nixos/modules";
        };
        modules = [
          inputs.self.modules.nixos.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};

              sharedModules = [
                inputs.plasma-manager.homeModules.plasma-manager
              ];
            };
          }
          inputs.agenix.nixosModules.default
        ];
      };
    };

    mkHome = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [inputs.self.modules.homeManager.${name}];
      };
    };
  };
}
