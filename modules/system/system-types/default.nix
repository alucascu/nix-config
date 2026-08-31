{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos = {
    system-default = {
      imports = with inputs.self.modules.nixos; [
        nix-settings
        locale
      ];

      hardware = {
        enableRedistributableFirmware = true;
        bluetooth.enable = true;
      };
      services.dbus.implementation = "broker";
      programs.nix-ld.enable = true;
    };

    system-cli = {pkgs, ...}: {
      imports = with inputs.self.modules.nixos; [
        system-default
      ];
      # Rescue tools: available to root and to any user without a home config.
      # The user-facing, configured copies of these come from home-manager.
      environment.systemPackages = with pkgs; [
        git
        neovim
        wget
        just
      ];
      programs.fish.enable = true;
      environment.variables.EDITOR = "nvim";
    };

    system-desktop = {
      imports = with inputs.self.modules.nixos; [
        system-cli
        desktop-kde
        libreoffice
        plymouth-nix-gruvbox
        pipewire
        printing
        limine-nix-gruvbox
      ];
      services = {
        pcscd.enable = true;
      };
    };
  };
}
