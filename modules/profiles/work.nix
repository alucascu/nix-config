{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
      globalprotect
    ];
  };

  flake.modules.homeManager.work = {
    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--profile-directory=work"
      ];
    };

    programs.firefox = {
      profiles.work = {
        settings = {
          "network.protocol-handler.expose.globalprotectcallback" = false;
          "network.protocol-handler.external.globalprotectcallback" = true;
          "network.protocol-handler.warn-external.globalprotectcallback" = false;
        };
      };
    };
  };
}
