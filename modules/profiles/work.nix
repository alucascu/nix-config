{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
      globalprotect
    ];
  };

  flake.modules.homeManager.work = {
    programs.firefox.profiles.alucascu.settings = {
      "network.protocol-handler.expose.globalprotectcallback" = false;
      "network.protocol-handler.external.globalprotectcallback" = true;
      "network.protocol-handler.warn-external.globalprotectcallback" = false;
    };
  };
}
