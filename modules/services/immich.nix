{
  flake.modules.nixos.immich = {config, ...}: {
    services = {
      immich = {
        enable = true;
        openFirewall = false;
      };

      caddy = {
        enable = true;
        virtualHosts."immich.local".extraConfig = ''
          reverse_proxy localhost:${toString config.services.immich.port}
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
