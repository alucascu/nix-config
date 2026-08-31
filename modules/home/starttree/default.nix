{inputs, ...}: {
  flake.modules.homeManager.starttree = {
    config,
    pkgs,
    lib,
    ...
  }: let
    python = pkgs.python3.withPackages (ps: [ps.pyyaml ps.beautifulsoup4]);
  in {
    imports = [inputs.self.modules.homeManager.browser];

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

    programs.firefox.profiles.${config.myConfig.firefoxProfile}.settings = {
      "browser.startup.homepage" = "file://${config.home.homeDirectory}/.cache/StartTree/index.html";
    };
  };
}
