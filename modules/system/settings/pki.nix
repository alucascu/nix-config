{...}: {
  flake.modules.nixos.pki = {
    security.pki.certificateFiles = [
      ../../../secrets/root.crt
    ];
  };
}
