{
  flake.modules.nixos.ventoy = {pkgs, ...}: {
    nixpkgs.config.permittedInsecurePackages = ["ventoy-qt5-1.1.17"];

    environment.systemPackages = [pkgs.ventoy-full-qt];
  };
}
