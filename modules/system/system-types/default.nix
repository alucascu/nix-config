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
      environment.systemPackages = with pkgs; [
        git
        neovim
        wget
        tmux
        just
        any-nix-shell
      ];
      programs.fish.enable = true;
      environment.variables.EDITOR = "nvim";
      programs.fish.interactiveShellInit = ''
        any-nix-shell fish | source
      '';
    };

    system-desktop = {
      imports = with inputs.self.modules.nixos; [
        system-cli
        desktop-kde
        pipewire
        printing
      ];
      services = {
        pcscd.enable = true;
      };
    };
  };
}
