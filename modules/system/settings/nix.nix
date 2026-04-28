{...}: {
  flake.modules.nixos.nix-settings = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = "nix-command flakes";
  };
}
