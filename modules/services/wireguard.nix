{inputs, ...}: {
  flake.modules.nixos.wireguard = {
    pkgs,
    config,
    ...
  }: {
    age.secrets.wireguard.file = "${inputs.self}/secrets/wireguard-${config.networking.hostName}.age";
    services.resolved.enable = true;
    networking.wireguard.interfaces.wg0 = {
      ips = ["10.100.0.2/24"];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard.path;
      postSetup = ''
        ${pkgs.systemd}/bin/resolvectl dns wg0 10.93.247.97
        ${pkgs.systemd}/bin/resolvectl domain wg0 ~lan
      '';

      postShutdown = ''
        ${pkgs.systemd}/bin/resolvectl revert wg0
      '';
      peers = [
        {
          publicKey = "RyeqM/aZ8+hr90PN5TASdcGOouZlXjZl9/VJVJy69x4=";
          endpoint = "apsu.crabdance.com:51820";
          allowedIPs = [
            "10.100.0.0/24"
            "10.93.247.0/24"
          ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
