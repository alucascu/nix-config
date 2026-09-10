{
  inputs,
  lib,
  ...
}: let
  # Both config types expose the resolved nixpkgs the same way, so one
  # predicate covers hosts and standalone home targets alike.
  forThisSystem = system: lib.filterAttrs (_: cfg: cfg.pkgs.stdenv.hostPlatform.system == system);
in {
  perSystem = {system, ...}: {
    checks =
      lib.mapAttrs'
      (name: cfg: lib.nameValuePair "nixos-${name}" cfg.config.system.build.toplevel)
      (forThisSystem system inputs.self.nixosConfigurations)
      // lib.mapAttrs'
      (name: cfg: lib.nameValuePair "home-${name}" cfg.activationPackage)
      (forThisSystem system inputs.self.homeConfigurations);
  };
}
