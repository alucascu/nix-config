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

    # OCaml — Mason can't install ocaml-lsp on NixOS
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat

    # F# / .NET — needs dotnet SDK on PATH
    dotnet-sdk_8
    fsautocomplete
    csharpier
    netcoredbg
    fantomas

    # TOML
    taplo
  ];
}
