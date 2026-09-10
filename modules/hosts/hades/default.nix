{inputs, ...}: {
  flake.modules.nixos.hades = {
    inputs,
    pkgs,
    lib,
    ...
  }: {
    imports =
      [
        ./_hardware-configuration.nix
      ]
      ++ (with inputs.self.modules.nixos; [
        desktop
        docker
        alucascu
        work
        fprintd
        thermald
        wireguard
        pki
        agenix
      ]);

    # p3 is a leftover LUKS swap partition the initrd never unlocked -- the
    # generated hwconfig names its mapper, but no boot.initrd.luks.devices
    # entry opens it. Re-key the raw partition per boot instead: no keyslot to
    # manage, no extra passphrase prompt, and no hibernation. by-partuuid is
    # required -- randomEncryption erases the header UUID on every boot.
    swapDevices = lib.mkForce [
      {
        device = "/dev/disk/by-partuuid/8858d831-d910-4e83-bfda-736cd6153c47";
        randomEncryption = {
          enable = true;
          allowDiscards = true;
        };
        discardPolicy = "once";
      }
    ];

    # Priority 5, so it is preferred over the disk swap above (default -2).
    zramSwap.enable = true;

    home-manager.users.alucascu.myConfig.sshKeyName = "hades";

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      math

      neovim-rust
      neovim-ocaml
      neovim-tex
      neovim-julia
    ];
    networking = {
      hostName = "hades";
      networkmanager.enable = true;
      wireless.enable = true;
    };
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    boot = {
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };
    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "hades";
}
