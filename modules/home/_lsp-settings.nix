# Language-server settings shared by the `neovim` and `vscode` aspects, so the
# two editors cannot drift apart. Plain data: neovim renders it to Lua, vscode
# takes it as JSON.
{
  lib,
  pkgs,
}: let
  flake = ''(builtins.getFlake "/home/alucascu/nix-config")'';
in {
  nixd = {
    nixpkgs.expr = "import ${flake}.inputs.nixpkgs {}";
    options = {
      nixos.expr = "${flake}.nixosConfigurations.hades.options";
      home_manager.expr = "${flake}.nixosConfigurations.hades.options.home-manager.users.type.getSubOptions []";
    };
    formatting.command = [(lib.getExe pkgs.alejandra)];
  };

  pyrefly.typeCheckingMode = "strict";

  rust-analyzer.lens.implementations.enable = false;
}
