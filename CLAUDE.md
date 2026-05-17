# Nix Configuration

Dendritic-pattern flake config using `flake-parts` and `import-tree`.
All modules live under `modules/` and are auto-imported recursively.
Files prefixed with `_` are excluded from auto-import and are internal
to their parent feature.

## Structure

```
.
├── flake.nix                          # inputs + import-tree bootstrap only
├── flake.lock
├── justfile                           # task runner shortcuts
├── inventory/                         # machine inventory (toml, sql schema, migration script)
└── modules/
    ├── nix/
    │   └── flake-parts/
    │       └── default.nix            # framework bootstrap, mkNixos, mkHome
    ├── system/
    │   ├── settings/
    │   │   ├── locale.nix             # aspect: locale — timezone (America/Detroit), i18n
    │   │   └── nix.nix                # aspect: nix-settings — allowUnfree, flakes
    │   └── system-types/
    │       └── default.nix            # system-default -> system-cli -> system-desktop
    ├── services/
    │   ├── pipewire.nix               # aspect: pipewire
    │   ├── docker.nix                 # aspect: docker
    │   ├── fprintd.nix                # aspect: fprintd — fingerprint reader
    │   ├── globalprotect.nix          # aspect: globalprotect — VPN (globalprotect-openconnect)
    │   └── restic.nix                 # aspect: restic — backups to external SSD
    ├── programs/
    │   ├── desktop-kde.nix            # aspect: desktop-kde — plasma6, sddm, printing
    │   ├── chromium.nix               # aspect: chromium
    │   └── libreoffice.nix            # aspect: libreoffice
    ├── profiles/
    │   ├── gaming.nix                 # aspects: gaming (nixos: steam, gamemode) + gaming (homeManager: mangohud)
    │   └── work.nix                   # aspect: work — bundles chromium + globalprotect
    ├── home/
    │   ├── core.nix                   # aspect: core — packages, session vars, stateVersion
    │   ├── shell.nix                  # aspect: shell — fish, starship, direnv, tmux
    │   ├── git.nix                    # aspect: git — git + gh config
    │   ├── ssh.nix                    # aspect: ssh
    │   ├── terminal.nix               # aspect: terminal — kitty (Gruvbox, Lilex Nerd Font)
    │   ├── browser.nix                # aspect: browser — BROWSER env var, xdg mime associations
    │   ├── gnupg.nix                  # aspect: gnupg — gpg + gpg-agent
    │   ├── plasma.nix                 # aspect: plasma — plasma-manager home config
    │   └── neovim/
    │       ├── default.nix            # aspect: neovim — imports lazyvim + internals
    │       ├── _extras.nix
    │       ├── _packages.nix
    │       ├── config/
    │       │   ├── _keymaps.nix
    │       │   └── _options.nix
    │       └── plugins/
    │           ├── _conform.nix
    │           ├── _lsp.nix
    │           └── _obsidian.nix
    ├── users/
    │   └── alucascu.nix               # NixOS user + homeManager aspects
    └── hosts/
        ├── hades/
        │   ├── default.nix            # host aspect + flake.nixosConfigurations
        │   └── _hardware-configuration.nix
        └── odysseus/
            ├── default.nix            # host aspect + flake.nixosConfigurations (nvidia, gaming)
            └── _hardware-configuration.nix
```

## Key Concepts

**Aspects** are named modules registered under `flake.modules.<class>.<name>`.
Classes used here: `nixos`, `homeManager`, `generic`.

**Features** are files or directories that register one or more aspects.
Only feature entry points are unprefixed — internal files use `_` prefix.

**Profiles** (`modules/profiles/`) bundle multiple aspects into a named configuration
for a use-case (e.g. `gaming`, `work`). A profile registers one or more nixos/homeManager
aspects and is imported from a host, just like any other aspect.

**System types** form an inheritance ladder:
- `system-default` — imports `nix-settings` + `locale`; adds dbus-broker, bluetooth, nix-ld
- `system-cli` — inherits system-default; adds git, neovim, wget, tmux, just; sets `EDITOR=nvim`
- `system-desktop` — inherits system-cli; adds `desktop-kde` + `pipewire`; enables pcscd

## Rebuild Commands

```bash
# NixOS system + home-manager (home-manager is managed by NixOS module)
sudo nixos-rebuild switch --flake .#hades
sudo nixos-rebuild switch --flake .#odysseus

# Check flake evaluates cleanly
nix flake check

# Standalone home-manager (not used — managed via NixOS module)
# home-manager switch --flake .#"alucascu@hades"
```

## Adding a New Host

1. Create `modules/hosts/<hostname>/default.nix`:

```nix
{ inputs, pkgs, ... }: {
  flake.modules.nixos.<hostname> = { inputs, pkgs, ... }: {
    imports = [ ./_hardware-configuration.nix ]
      ++ (with inputs.self.modules.nixos; [
        system-desktop
        docker
        alucascu
      ]);

    networking.hostName = "<hostname>";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;

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

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "<hostname>";
}
```

2. Copy `hardware-configuration.nix` into the host directory, prefixed with `_`.
3. `git add` the new files — `import-tree` picks them up automatically.
4. `sudo nixos-rebuild switch --flake .#<hostname>`

## Adding a New User

1. Create `modules/users/<username>.nix`:

```nix
{ inputs, ... }: {
  flake.modules.nixos.<username> = {
    users.users.<username> = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      openssh.authorizedKeys.keys = [];
    };
    home-manager.users.<username>.imports = [
      inputs.self.modules.homeManager.<username>
    ];
  };

  flake.modules.homeManager.<username> = {
    imports = with inputs.self.modules.homeManager; [
      core shell git neovim ssh terminal
    ];
  };
}
```

2. Import the user aspect from the host: add `<username>` to the host's imports.

## Adding a New Home Module

Simple case — wraps a home-manager config as an aspect:

```nix
# modules/home/<name>.nix
{ ... }: {
  flake.modules.homeManager.<name> = { pkgs, ... }: {
    programs.<name>.enable = true;
  };
}
```

Complex case with internal files — only `default.nix` is a feature module,
internal files are prefixed with `_`:

```
modules/home/<name>/
├── default.nix       # registers flake.modules.homeManager.<name>, imports internals
├── _config.nix       # plain home-manager module
└── _packages.nix     # plain home-manager module
```

Then add `<name>` to the user's homeManager aspect imports.

## Adding a New NixOS Service/Program

```nix
# modules/services/<name>.nix
{ ... }: {
  flake.modules.nixos.<name> = {
    services.<name>.enable = true;
  };
}
```

Then add `<name>` to the appropriate system-type or host imports.

## Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable |
| `home-manager` | follows nixpkgs (master branch) |
| `flake-parts` | module registry, flake output wiring |
| `import-tree` | recursive auto-import of modules/ |
| `lazyvim` | LazyVim home-manager module (pfassina/lazyvim-nix) |
| `plasma-manager` | plasma-manager home-manager module (nix-community/plasma-manager) |
| `globalprotect-openconnect` | GlobalProtect VPN client (yuezk/globalprotect-openconnect) |

## Important Rules

- Never import files that set `flake.modules.*` from within a NixOS/homeManager
  module — only import plain modules there.
- `imports` inside aspects must be unconditional — use `lib.mkMerge` +
  `lib.mkIf` for conditional config, never conditional imports.
- `pkgs` must be requested at the aspect (inner) function level, not the
  flake-parts (outer) level.
- Internal files used by a feature must be prefixed with `_` to prevent
  `import-tree` from treating them as top-level feature modules.
- Always `git add` new files before rebuilding — Nix flakes only see
  staged/committed files.
- The `nix.nix` settings file registers as aspect `nix-settings` (not `nix`) —
  used by `system-default`.
