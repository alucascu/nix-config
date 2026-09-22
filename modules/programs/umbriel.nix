{inputs, ...}: {
  flake.modules.nixos.umbriel = {
    programs.umbriel.enable = true;

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      umbriel
      noctalia
    ];
  };

  flake.modules.homeManager.umbriel = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.myConfig.umbriel.settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = ''
        Host-specific Umbriel settings, merged over the shared config below.
        Machine-dependent tables -- `output` above all -- belong here rather
        than in this aspect, which every Umbriel host shares.
      '';
    };

    config.xdg.configFile."umbriel/config.toml".source = (pkgs.formats.toml {}).generate "umbriel-config.toml" (lib.recursiveUpdate {
        include.files = ["${pkgs.umbriel}/share/umbriel/config.toml"];

        general.autostart = ["noctalia"];

        input.keyboard = {
          layout = "us,fi";
        };

        keybinds = {
          # Focus
          "Super+Up" = "window-focus-or-output-up";
          "Super+Ctrl+Up" = "output-focus-up";
          "Super+K" = "window-focus-or-output-up";
          "Super+Ctrl+K" = "output-focus-up";

          "Super+Down" = "window-focus-or-output-down";
          "Super+Ctrl+Down" = "output-focus-down";
          "Super+J" = "window-focus-or-output-down";
          "Super+Ctrl+J" = "output-focus-down";

          "Super+Left" = "window-focus-or-output-left";
          "Super+Ctrl+Left" = "output-focus-left";
          "Super+H" = "window-focus-or-output-left";
          "Super+Ctrl+H" = "output-focus-left";

          "Super+Right" = "window-focus-or-output-right";
          "Super+Ctrl+Right" = "output-focus-right";
          "Super+L" = "window-focus-or-output-right";
          "Super+Ctrl+L" = "output-focus-right";

          # Noctalia
          "Mod+S" = "spawn:noctalia msg panel-toggle control-center";
          "Mod+Shift+A" = "spawn:noctalia msg screenshot-annotate";
          "Alt+Tab" = "spawn:noctalia msg window-switcher";
          "Alt+Shift+S" = "spawn: noctalia msg screenshot-region";

          ## Enabling the 'system' keys
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

          # Windows
          "Mod+Ctrl+S" = "workspace-set-layout:scrolling";
          "Mod+Ctrl+D" = "workspace-set-layout:dwindle";
          "Mod+Ctrl+M" = "workspace-set-layout:master";

          "Mod+U" = "scratchpad-toggle"; # opens the scratchpad
          "Mod+Shift+U" = "window-toggle-scratchpad"; # moves current window to scratchpad

          # Input
          "Super+Alt+K" = "keyboard-layout-next";

          # Apps
          "Mod+B" = "spawn:firefox";
          "Mod+Return" = "spawn:kitty";
          "Mod+K" = "cheatsheet-toggle";
        };
      }
      config.myConfig.umbriel.settings);
  };
}
