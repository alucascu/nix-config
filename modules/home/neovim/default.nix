{
  imports = [
    ./plugins
    ./extras.nix
    ./packages.nix
  ];

  programs.lazyvim.enable = true;
}
