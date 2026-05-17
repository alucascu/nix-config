{inputs, ...}: {
  flake.modules.nixos = {
    system-default = {
      imports = with inputs.self.modules.nixos; [
        nix-settings
        locale
      ];

      services.dbus.implementation = "broker";
      hardware.bluetooth.enable = true;
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
      ];
      services = {
        pcscd.enable = true;
      };
    };
  };
}
