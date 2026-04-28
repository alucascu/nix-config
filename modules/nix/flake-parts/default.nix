# modules/nix/flake-parts/default.nix
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
        modules = [
          inputs.self.modules.nixos.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
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
