{...}: {
  # ~1.2 GB. lazyvim-nix maps no packages for this extra — opam is on its
  # unmapped package-manager list — so every tool here is ours to provide.
  flake.modules.homeManager.neovim-ocaml = {
    key = "neovim-ocaml";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.ocaml.enable = true;

        programs.lazyvim.extraPackages = with pkgs; [
          ocamlPackages.ocaml-lsp
          ocamlPackages.ocamlformat
          ocamlPackages.findlib
          dune_3
          ocamlPackages.utop # ~0.9 GB of this aspect: the REPL pulls the compiler
        ];
      })
    ];
  };
}
