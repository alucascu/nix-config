{
  flake.modules.nixos.ollama = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "10.3.0";
      host = "127.0.0.1";
      port = 11434;
    };
    networking.firewall.allowedTCPPorts = [11434];
  };
}
