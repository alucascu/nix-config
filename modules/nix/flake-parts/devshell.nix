{inputs, ...}: {
  flake.devShells.x86_64-linux.default = let
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in
    pkgs.mkShell {
      packages = with pkgs; [
        python3
        just
        sqlite
      ];
    };
}
