{pkgs, ...}: {
  programs.lazyvim.extraPackages = with pkgs; [
    nixd
    nixfmt
    alejandra
    statix
    ty
    pplatex
  ];
}
