{...}: {
  flake.modules.homeManager.firefox = {...}: {
    programs.firefox.profiles.default = {
      settings = {
        "network.protocol-handler.expose.globalprotectcallback" = false;
        "network.protocol-handler.external.globalprotectcallback" = true;
        "network.protocol-handler.warn-external.globalprotectcallback" = false;
      };
    };
  };
}
