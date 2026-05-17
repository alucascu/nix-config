{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
      globalprotect
    ];
  };

  flake.modules.homeManager.work = {
    programs.firefox = {
      profiles.work = {
        isDefault = false;
        id = 1;
        settings = {
          "network.protocol-handler.expose.globalprotectcallback" = false;
          "network.protocol-handler.external.globalprotectcallback" = true;
          "network.protocol-handler.warn-external.globalprotectcallback" = false;
        };
      };
    };
  };
}
