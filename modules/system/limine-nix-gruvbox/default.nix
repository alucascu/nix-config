{ ... }:
{
  # Adds gruvbox styling to Limine's boot menu. Assumes the host already
  # sets `boot.loader.limine.enable = true` and its own partition/EFI
  # config — this aspect only layers `style.*` on top.
  flake.modules.nixos.limine-nix-gruvbox = {
    boot.loader.limine.style = {
      wallpapers = [ ./assets/snowflake.png ];
      wallpaperStyle = "centered";
      backdrop = "282828"; # gruvbox bg0

      interface = {
        # Pin the menu to a fixed 1080p canvas so the centered snowflake
        # wallpaper is the same relative size on every machine regardless of
        # panel resolution. Firmware scales this canvas to the physical panel.
        resolution = "1920x1080";
        branding = "NixOS";
        brandingColor = "83A598"; # gruvbox aqua
        helpColor = "FABD2F"; # gruvbox yellow
        helpColorBright = "FE8019"; # gruvbox orange (autoboot countdown digit)
        helpHidden = false;
      };

      graphicalTerminal = {
        # TTRRGGBB: TT is transparency (00 = opaque, FF = fully clear). Fully
        # transparent so the centered snowflake wallpaper shows through the
        # terminal at full brightness. Limine discards the PNG's alpha channel,
        # so the wallpaper (assets/snowflake.png) must bake in this bg0 color
        # as its background rather than relying on transparency. The RGB here
        # is irrelevant at TT=FF but kept as bg0 for documentation.
        background = "FF282828";
        foreground = "EBDBB2"; # gruvbox fg1
        brightBackground = "3C3836"; # gruvbox bg1
        brightForeground = "FBF1C7"; # gruvbox fg0

        # black;red;green;brown/yellow;blue;magenta;cyan;white
        palette = "282828;CC241D;98971A;D79921;458588;B16286;689D6A;A89984";
        # bright variants, same order
        brightPalette = "928374;FB4934;B8BB26;FABD2F;83A598;D3869B;8EC07C;EBDBB2";
      };
    };
  };
}
