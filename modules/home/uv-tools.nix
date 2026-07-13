{
  flake.modules.homeManager.uv-tools = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = [pkgs.uv];

    home.activation.uvTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
      export PATH="${pkgs.uv}/bin:$PATH"
      for tool in repowise ; do
        run uv tool install --quiet "$tool"
      done
    '';
  };
}
