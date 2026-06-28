{
  flake.modules.homeManager.discord = {
    programs.vesktop = {
      enable = true;
      vencord.settings = {
        autoUpdate = true;
        plugins.FixYoutubeEmbeds.enabled = true;
      };
    };
  };
}
