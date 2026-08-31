{...}: {
  # ~8.1 GB: haskell-language-server pulls GHC, and is the single largest
  # item in the tree. The `haskell-debug-adapter` tool in this extra has no
  # nixpkgs mapping upstream, so it comes from extraPackages instead — the
  # resulting eval warning only appears on hosts that import this aspect.
  flake.modules.homeManager.neovim-haskell = {
    key = "neovim-haskell";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.haskell = {
          enable = true;
          installDependencies = true; # haskell-language-server
        };

        programs.lazyvim.extraPackages = [pkgs.haskellPackages.haskell-debug-adapter];
      })
    ];
  };
}
