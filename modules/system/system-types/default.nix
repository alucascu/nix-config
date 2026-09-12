{inputs, ...}: {
  flake.modules.nixos = {
    system-default = {lib, ...}: {
      imports = with inputs.self.modules.nixos; [
        nix-settings
        locale
        fwupd
        earlyoom
      ];

      hardware = {
        enableRedistributableFirmware = true;
        bluetooth.enable = true;
      };
      services.dbus.implementation = "broker";
      programs.nix-ld.enable = true;
      boot.tmp.cleanOnBoot = true;
      # Limine copies a kernel + initrd per listed generation onto the ESP and
      # only prunes after copying the new pair; unbounded, a 512M ESP fills up.
      boot.loader.limine.maxGenerations = lib.mkDefault 5;
    };

    system-cli = {pkgs, ...}: {
      imports = with inputs.self.modules.nixos; [
        system-default
        nh
        nix-index
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
      documentation.man.cache.enable = true;
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
        fonts
        appimage
      ];
      services = {
        pcscd.enable = true;
      };
      # Backing store for the GTK settings the `gtk` home aspect writes.
      programs.dconf.enable = true;
    };
  };
}
