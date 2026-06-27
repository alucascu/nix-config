{
  flake.modules.nixos.obs-studio = {pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [obs-backgroundremoval];
    };
  };
}
