{
  flake.modules.nixos.open-webui = {
    services.open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = 11435;
      environment = {
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        WEBUI_AUTH = "False";
      };
    };

    services.caddy.virtualHosts."http://ai.tantalus.lan:8080" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:11435
      '';
    };

    networking.firewall.allowedTCPPorts = [8080];
  };
}
