{pkgs, ...}: {
  programs.lazyvim.extraPackages = with pkgs; [
    # Nix
    nixd
    nixfmt
    alejandra
    statix

    # Python
    ruff
    ty

    # Haskell
    haskellPackages.haskell-debug-adapter

    # LaTeX
    pplatex

    # Rust
    rust-analyzer

    # OCaml toolchain
    ocamlPackages.OCaml
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    dune_3
    ocamlPackages.findlib
    ocamlPackages.utop

    # F# / .NET — needs dotnet SDK on PATH
    dotnet-sdk_8
    fsautocomplete
    csharpier
    netcoredbg
    fantomas

    # TOML
    taplo

    # Typescript
    vtsls
    prettierd
    vscode-langservers-extracted
  ];
}
