{inputs, ...}: {
  flake.modules.homeManager.starttree = {
    pkgs,
    lib,
    ...
  }: let
    python = pkgs.python3.withPackages (ps: [ps.pyyaml ps.beautifulsoup4]);
  in {
    home.file.".config/StartTree/config.yaml".source = ./config.yaml;

    home.activation.starttree = lib.hm.dag.entryAfter ["writeBoundary"] ''
      WORK="$HOME/.local/share/StartTree"
      mkdir -p "$WORK" "$HOME/.cache/StartTree"

      ln -sf ${inputs.starttree}/generate.py "$WORK/generate.py"
      ln -sf ${inputs.starttree}/themes      "$WORK/themes"
      ln -sf ${inputs.starttree}/skeletons   "$WORK/skeletons"
      ln -sf "$HOME/.config/StartTree/config.yaml" "$WORK/config.yaml"

      cd "$WORK"
      ${python}/bin/python3 generate.py
    '';

    programs.firefox.profiles.alucascu.settings = {
      "browser.startup.homepage" = "file:///home/alucascu/.cache/StartTree/index.html";
    };
  };
}
