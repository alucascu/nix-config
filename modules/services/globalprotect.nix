{inputs, ...}: {
  flake.modules.nixos.globalprotect = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.globalprotect-openconnect.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
