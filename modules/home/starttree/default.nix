{inputs, ...}: {
  flake.modules.homeManager.starttree = {
    pkgs,
    lib,
    ...
  }: let
    python = pkgs.python3.withPackages (ps: [ps.pyyaml ps.beautifulsoup4]);
  in {
    home.file.".config/StartTree/config.yaml".source = ./config.yaml;

    # generate.py reads its skeletons/themes from and writes index.html into
    # ~/.cache/StartTree, so the supporting trees must live there.
    home.activation.starttree = lib.hm.dag.entryAfter ["writeBoundary"] ''
      CACHE="$HOME/.cache/StartTree"
      mkdir -p "$CACHE/styles"

      ln -sfn ${inputs.starttree}/themes    "$CACHE/themes"
      ln -sfn ${inputs.starttree}/skeletons "$CACHE/skeletons"

      ${python}/bin/python3 ${inputs.starttree}/generate.py
    '';

    programs.firefox.profiles.alucascu.settings = {
      "browser.startup.homepage" = "file:///home/alucascu/.cache/StartTree/index.html";
    };
  };
}
