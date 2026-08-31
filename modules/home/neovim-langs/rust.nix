{...}: {
  # ~1.6 GB, nearly all of it codelldb, which bundles LLDB and its LLVM libs.
  flake.modules.homeManager.neovim-rust = {
    key = "neovim-rust";

    programs.lazyvim.extras.lang.rust = {
      enable = true;
      installDependencies = true; # rust-analyzer, codelldb, bacon
    };
  };
}
