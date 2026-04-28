{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Import NixOS modules
  imports = [
    ./hardware-configuration.nix
    inputs.self.modules.nixos.system-default
    inputs.self.modules.nixos.system-cli
    inputs.self.modules.nixos.system-desktop
    inputs.self.modules.nixos.alucascu
  ];

  nixpkgs.overlays = [
    # Overlays exported from other flakes
    # neovim-nightly-overlay.overlays.default

    # Overlays defined inline
    # (final: prev: {
    #   hi = final.hello.overrideAttr (oldAttr: {
    #     patches = [./change-hello-to-hi.patch];
    #   });
    # });
  ];

  boot = {
    loader.limine.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Latest linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.luks.devices."luks-8a0d2ba6-be48-40a2-8b7f-920b39918f05".device = "/dev/disk/by-uuid/8a0d2ba6-be48-40a2-8b7f-920b39918f05";
  };

  networking.hostName = "hades";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker
    uv
  ];

  # Do not mess with this unless you have a REALLY good reason!
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
