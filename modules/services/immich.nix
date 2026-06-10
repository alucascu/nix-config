{
  flake.modules.nixos.immich = {config, ...}: {
    services = {
      immich = {
        enable = true;
        openFirewall = false;
        host = "0.0.0.0";
      };

      caddy = {
        enable = true;
        virtualHosts."http://immich.lan".extraConfig = ''
          reverse_proxy 127.0.0.1:2283
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
