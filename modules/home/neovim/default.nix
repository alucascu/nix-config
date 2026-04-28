{
  imports = [
    ./plugins
    ./config
    ./extras.nix
    ./packages.nix
  ];

  programs.lazyvim.enable = true;
}
