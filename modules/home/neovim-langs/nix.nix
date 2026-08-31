{...}: {
  # lazyvim-nix maps no packages for this extra, so the toolchain is ours.
  flake.modules.homeManager.neovim-nix = {
    key = "neovim-nix";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.nix.enable = true;

        programs.lazyvim.extraPackages = with pkgs; [
          nixd
          nixfmt
          alejandra
          statix
        ];
      })
    ];
  };
}
