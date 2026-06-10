{...}: {
  flake.modules.nixos.nix-settings = {
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings.experimental-features = "nix-command flakes";
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      optimise.automatic = true;
    };
  };
}
