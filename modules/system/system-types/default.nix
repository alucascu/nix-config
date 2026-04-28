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
      ];

      environment.variables.EDITOR = "nvim";
    };

    system-desktop = {
      imports = with inputs.self.modules.nixos; [
        system-cli
        desktop-kde
        pipewire
      ];
    };
  };
}
