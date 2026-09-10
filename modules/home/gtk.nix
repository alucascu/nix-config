{
  flake.modules.homeManager.gtk = {
    config,
    pkgs,
    ...
  }: {
    # Plasma themes Qt applications itself (see the `plasma` aspect), but GTK
    # apps -- firefox, thunderbird, signal-desktop, the Electron set -- read
    # their own settings.ini and otherwise render in stock Adwaita next to a
    # Gruvbox desktop. Requires programs.dconf at the system level, which
    # system-desktop enables.
    gtk = {
      enable = true;

      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };

      # Same icon theme plasma-manager sets for the workspace.
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };

      font = {
        name = "Noto Sans";
        size = 10;
      };

      # GTK4 ignores gtk-theme-name, so home-manager works around it by
      # @import-ing the theme's stylesheet from ~/.config/gtk-4.0/gtk.css. That
      # is the pre-26.05 default and what we want; state it explicitly so the
      # stateVersion bump doesn't silently turn GTK4 theming off.
      gtk4.theme = config.gtk.theme;
    };
  };
}
