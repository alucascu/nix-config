{...}: {
  flake.modules.nixos.desktop-kde = {pkgs, ...}: {
    services = {
      displayManager = {
        defaultSession = "plasma";
        sddm.enable = true;
      };

      desktopManager.plasma6.enable = true;
      xserver.xkb = {
        layout = "us";
        variant = "";
      };

      printing.enable = true;
    };

    programs.firefox.enable = true;
    environment.systemPackages = with pkgs; [libreoffice];
  };
}
