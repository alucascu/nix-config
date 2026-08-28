{
  flake.modules.nixos.immich = {inputs, ...}: {
    imports = [inputs.self.modules.nixos.caddy];

    services = {
      immich = {
        enable = true;
        openFirewall = false;
        host = "0.0.0.0";
      };

      caddy.virtualHosts."http://immich.lan".extraConfig = ''
        reverse_proxy 127.0.0.1:2283
      '';
    };
  };
}
