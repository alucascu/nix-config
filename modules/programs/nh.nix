{...}: {
  flake.modules.nixos.nh = {lib, ...}: {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 14d";
      };
    };

    nix.gc.automatic = lib.mkForce false;
  };
}
