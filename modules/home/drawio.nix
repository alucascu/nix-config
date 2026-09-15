{
  flake.modules.homeManager.drawio = {pkgs, ...}: {
    home.packages = [pkgs.drawio];
  };
}
