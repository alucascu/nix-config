{
  flake.modules.nixos.ollama = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [inputs.self.modules.nixos.caddy];

    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "10.3.0";
      host = "127.0.0.1";
      port = 11434;
      environmentVariables = {
        OLLAMA_NUM_CTX = "16384";
      };
    };

    # Bound to loopback; reachable only through Caddy.
    services.caddy.virtualHosts."http://ollama.tantalus.lan".extraConfig = ''
      reverse_proxy 127.0.0.1:11434
    '';

    systemd.services.ollama-create-models = {
      description = "Create custom Ollama models";
      after = ["ollama.service"];
      wants = ["ollama.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "ollama-create-models" ''
          cat > /var/lib/ollama/qwen3.5-16k.modelfile << 'EOF'
          FROM qwen3.5:9b
          PARAMETER num_ctx 16384
          EOF
          ${pkgs.ollama-rocm}/bin/ollama create qwen3.5:16k -f /var/lib/ollama/qwen3.5-16k.modelfile
        '';
        Environment = [
          "OLLAMA_HOST=http://127.0.0.1:11434"
          "HOME=/var/lib/ollama"
        ];
      };
    };
  };
}
