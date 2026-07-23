{ ... }:
{
  flake.modules.nixos.plymouth-nix-gruvbox = { pkgs, ... }:
    let
      nix-gruvbox-plymouth = pkgs.stdenv.mkDerivation {
        pname = "plymouth-theme-nix-gruvbox";
        version = "1.0.0";
        src = ./assets;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/plymouth/themes/nix-gruvbox
          cp $src/nix-gruvbox.plymouth $out/share/plymouth/themes/nix-gruvbox/
          cp $src/nix-gruvbox.script $out/share/plymouth/themes/nix-gruvbox/
          cp $src/snowflake.png $out/share/plymouth/themes/nix-gruvbox/
        '';
      };
    in
    {
      boot.plymouth = {
        enable = true;
        theme = "nix-gruvbox";
        themePackages = [ nix-gruvbox-plymouth ];
      };

      # Silent boot so the splash isn't interrupted by kernel log spam.
      boot.consoleLogLevel = 3;
      boot.initrd.verbose = false;
      boot.kernelParams = [ "quiet" "udev.log_level=3" "systemd.show_status=auto" ];
    };
}
