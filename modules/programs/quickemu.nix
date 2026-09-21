{
  perSystem = {pkgs, ...}: {
    packages.virtio-win-iso = pkgs.virtio-win.src;
  };

  flake.modules.nixos.quickemu = {pkgs, ...}: {
    environment.systemPackages = [pkgs.quickemu pkgs.cdrtools];

    boot.extraModprobeConfig = ''
      options kvm ignore_msrs=Y
      options kvm_amd nested=1
      options kvm_intel nested=1
    '';

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
