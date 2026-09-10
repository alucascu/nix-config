{
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.lilex
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];

      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["Lilex Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
