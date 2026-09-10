{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages =
        (with pkgs; [
          # Inventory (see inventory/README.md)
          python3
          sqlite

          # Task runner
          just

          # Authoring: the same three tools the pre-commit story would use, and
          # the language server neovim already gets from `neovim-nix`.
          alejandra
          statix
          deadnix
          nixd

          # Inspection
          nix-tree
          nix-output-monitor
          nvd
        ])
        ++ [
          # For `just rekey` and hand-editing .age files under secrets/.
          inputs.agenix.packages.${system}.default
        ];
    };
  };
}
