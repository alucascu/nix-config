{inputs, ...}: {
  flake.modules.nixos.openvpn = {config, ...}: {
    age.secrets.vpn = {
      file = "${inputs.self}/secrets/vpn.age";
    };
    services.openvpn.servers.vpn = {
      config = ''
        config ${config.age.secrets.vpn.path}
        dhcp-option DNS 10.93.247.97
      '';
      updateResolvConf = true;
      autoStart = false;
    };
  };
}
