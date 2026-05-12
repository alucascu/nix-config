{pkgs, ...}: {
  flake.modules.nixos.globalprotect = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gpclient
      gpauth
    ];
  };
}
