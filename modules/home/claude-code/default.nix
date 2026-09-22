{...}: {
  flake.modules.homeManager.claude-code = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = [
      (pkgs.claude-code.override {
        manifest = lib.importJSON ./_manifest.json;
      })
    ];
  };
}
