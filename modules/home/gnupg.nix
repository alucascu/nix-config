{...}: {
  flake.modules.homeManager.gnupg = {pkgs, ...}: {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
      enableSshSupport = false;
    };
  };
}
