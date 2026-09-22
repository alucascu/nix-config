{inputs, ...}: {
  flake.modules.nixos.umbriel = {
    programs.umbriel.enable = true;

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      umbriel
      noctalia
    ];
  };

  flake.modules.homeManager.umbriel = {pkgs, ...}: {
    xdg.configFile."umbriel/config.toml".source = (pkgs.formats.toml {}).generate "umbriel-config.toml" {
      include.files = ["${pkgs.umbriel}/share/umbriel/config.toml"];

      general.autostart = ["noctalia"];
      input.keyboard.layout = "us";
      keybinds = {
        "Mod+S" = "spawn:noctalia msg panel-toggle control-center";
        "Mod+Shift+A" = "spawn:noctalia msg screenshot-annotate";
        "Alt+Tab" = "spawn:noctalia msg window-switcher";
        "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
        "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
        "XF86AudioMute" = "spawn:noctalia msg volume-mute";
        "XF86MonBrightnessUp" = {
          action = "spawn:noctalia msg brightness-up";
          allow_when_locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = "spawn:noctalia msg brightness-down";
          allow_when_locked = true;
        };
        "Mod+K" = "cheatsheet-toggle";
        "Mod+B" = "spawn:firefox";
        "Mod+U" = "scratchpad-toggle";
        "Mod+Shift+U" = "window-toggle-scratchpad";
        "Mod+Ctrl+S" = "workspace-set-layout:scrolling";
        "Mod+Ctrl+D" = "workspace-set-layout:dwindle";
        "Mod+Ctrl+M" = "workspace-set-layout:master";
      };
    };
  };
}
