{
  flake.modules.homeManager.noctalia = {
    programs.noctalia = {
      enable = true;

      settings = {
        shell = {
          font_family = "Lilex Nerd Font";

          polkit_agent = true;
        };

        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Gruvbox";
        };

        wallpaper = {
          enabled = true;
          default.path = "${../../assets/nixos-wallpaper-gruvbox.png}";
        };
      };
    };
  };
}
