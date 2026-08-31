# Nix Configuration

Dendritic-pattern flake config using `flake-parts` and `import-tree`.
All modules live under `modules/` and are auto-imported recursively.
Files prefixed with `_` are excluded from auto-import and are internal
to their parent feature.

## Structure

`import-tree` walks `modules/` recursively, so a directory is a grouping for
humans, not something the framework knows about. Only the shape below is load
bearing; the per-file listing lives in the aspect index further down, which is
generated rather than maintained by hand.

```
.
├── flake.nix              # inputs + import-tree bootstrap only
├── flake.lock
├── justfile               # task runner shortcuts (see Commands)
├── secrets/               # agenix .age files + secrets.nix recipient list
├── assets/                # wallpapers referenced by home aspects
├── inventory/             # machine inventory: toml source, sqlite schema,
│                          #   and build/validate/render scripts
└── modules/
    ├── boot/              # boot-time theming (plymouth, limine)
    ├── home/              # home-manager aspects — one per program or concern
    ├── homes/             # standalone home-manager targets (non-NixOS)
    ├── hosts/             # NixOS machines; each owns _hardware-configuration.nix
    ├── nix/flake-parts/   # framework bootstrap: mkNixos, mkHome, devshell, formatter
    ├── profiles/          # use-case bundles: desktop, gaming, work
    ├── programs/          # NixOS-level program aspects
    ├── services/          # NixOS service aspects
    ├── system/            # settings/ (locale, nix, pki) + system-types/
    └── users/             # NixOS user + their homeManager aspect
```

`modules/home/` (singular) holds reusable home-manager *aspects*.
`modules/homes/` (plural) holds standalone home-manager *targets* — a machine
where Nix is installed but NixOS is not. Keep the distinction: `hosts/` produces
`nixosConfigurations`, `homes/` produces `homeConfigurations`.

## Key Concepts

**Aspects** are named modules registered under `flake.modules.<class>.<name>`.
Classes used here: `nixos`, `homeManager`.

**Features** are files or directories that register one or more aspects.
Only feature entry points are unprefixed — internal files use `_` prefix.

**Profiles** (`modules/profiles/`) bundle multiple aspects into a named
configuration for a use-case. A profile registers one or more nixos/homeManager
aspects and is imported from a host, just like any other aspect. Where a profile
has both halves, the nixos half attaches its own home-manager side via
`home-manager.sharedModules` so the profile never needs to know the username.

**System types** form an inheritance ladder:

- `system-default` — imports `nix-settings` + `locale`; adds redistributable
  firmware, bluetooth, dbus-broker, nix-ld
- `system-cli` — inherits `system-default`; enables fish, sets `EDITOR=nvim`,
  and installs `git neovim wget just` as *rescue* tools for root and for users
  with no home config. The configured copies come from home-manager.
- `system-desktop` — inherits `system-cli`; imports `desktop-kde`,
  `libreoffice`, `pipewire`, `printing`, `plymouth-nix-gruvbox`, and
  `limine-nix-gruvbox`; enables pcscd

## Aspect index

Regenerate with:

```bash
grep -rn 'flake\.modules\.\(nixos\|homeManager\)\.[A-Za-z0-9_-]*' modules --include=*.nix -o \
  | sed 's|^modules/||; s|:[0-9]*:flake\.modules\.| |' \
  | awk '{split($2,a,"."); printf "%-22s %-12s %s\n", a[2], a[1], $1}' | sort -k2,2 -k1,1
```

The three system types are declared as one attrset and do not show up in that
grep; they live in `system/system-types/default.nix`.

### `nixos`

| Aspect | File | Notes |
|---|---|---|
| `agenix` | `services/agenix.nix` | secret decryption |
| `alucascu` | `users/alucascu.nix` | the NixOS user; pulls in the homeManager half |
| `caddy` | `services/caddy.nix` | reverse proxy; owns ports 80/443 |
| `chromium` | `programs/chromium.nix` | managed policies + `chromium-work` launcher |
| `desktop` | `profiles/desktop.nix` | profile: `system-desktop` + homeManager `desktop` |
| `desktop-kde` | `programs/desktop-kde.nix` | plasma6 + sddm |
| `docker` | `services/docker.nix` | |
| `fprintd` | `services/fprintd.nix` | fingerprint reader |
| `freshrss` | `services/freshrss.nix` | uses agenix; served by `caddy` |
| `gaming` | `profiles/gaming.nix` | profile: steam, gamemode + homeManager `gaming` |
| `gitlab` | `services/gitlab.nix` | |
| `globalprotect` | `services/globalprotect.nix` | VPN; also registers a homeManager aspect |
| `immich` | `services/immich.nix` | |
| `immich-backup` | `services/immich-backup.nix` | the restic backups that actually run |
| `karakeep` | `services/karakeep.nix` | |
| `libreoffice` | `programs/libreoffice.nix` | |
| `limine-nix-gruvbox` | `boot/limine-nix-gruvbox/default.nix` | boot menu styling only |
| `locale` | `system/settings/locale.nix` | timezone America/Detroit, i18n |
| `nix-settings` | `system/settings/nix.nix` | allowUnfree, flakes |
| `obs-studio` | `programs/obs-studio.nix` | |
| `ollama` | `services/ollama.nix` | |
| `open-webui` | `services/open-webui.nix` | |
| `pipewire` | `services/pipewire.nix` | |
| `pki` | `system/settings/pki.nix` | org CA trust |
| `plymouth-nix-gruvbox` | `boot/plymouth-nix-gruvbox/default.nix` | splash + silent boot |
| `printing` | `services/printing.nix` | cups + avahi |
| `restic` | `services/restic.nix` | **unused** — imported by no host |
| `searxng` | `services/searxng.nix` | |
| `system-default` / `system-cli` / `system-desktop` | `system/system-types/default.nix` | see above |
| `v4l2loopback` | `services/v4l2loopback.nix` | |
| `wireguard` | `services/wireguard.nix` | also registers a homeManager aspect |
| `work` | `profiles/work.nix` | profile: chromium + globalprotect |
| `hades` / `odysseus` / `tantalus` | `hosts/<name>/default.nix` | the machines |

### `homeManager`

| Aspect | File |
|---|---|
| `alucascu` | `users/alucascu.nix` — identity + the CLI set |
| `browser` | `home/browser.nix` — firefox, BROWSER, xdg mime |
| `core` | `home/core.nix` — packages, session vars, stateVersion |
| `desktop` | `profiles/desktop.nix` — the graphical bundle |
| `desktop-apps` | `home/desktop-apps.nix` |
| `discord` | `home/discord.nix` |
| `ffmpeg` | `home/ffmpeg.nix` |
| `gaming` | `profiles/gaming.nix` — mangohud |
| `git` | `home/git.nix` — git + gh |
| `globalprotect` | `services/globalprotect.nix` |
| `gnupg` | `home/gnupg.nix` |
| `mpv` | `home/mpv.nix` |
| `neovim` | `home/neovim/default.nix` — LazyVim + internals |
| `plasma` | `home/plasma.nix` — plasma-manager |
| `shell` | `home/shell.nix` — fish, starship, direnv, tmux, zoxide, eza |
| `ssh` | `home/ssh.nix` — defines `myConfig.sshKeyName` |
| `starttree` | `home/starttree/default.nix` |
| `tagstudio` | `home/tagstudio.nix` |
| `terminal` | `home/terminal.nix` — kitty (Gruvbox, Lilex Nerd Font) |
| `ubuntu` | `homes/ubuntu/default.nix` — standalone target |
| `uv-tools` | `home/uv-tools.nix` |
| `vlc` | `home/vlc.nix` |
| `vscode` | `home/vscode.nix` |
| `wireguard` | `services/wireguard.nix` |
| `work` | `profiles/work.nix` |
| `zellij` | `home/zellij.nix` |

## Commands

```bash
# NixOS system + home-manager (home-manager is managed by the NixOS module)
sudo nixos-rebuild switch --flake .#hades
sudo nixos-rebuild switch --flake .#odysseus
sudo nixos-rebuild switch --flake .#tantalus

# Standalone home-manager, for the non-NixOS targets in modules/homes/
home-manager switch --flake .#ubuntu
```

`just` wraps the common ones:

| Recipe | Does |
|---|---|
| `just rebuild` | rebuild the current host |
| `just rebuild-host <name>` | rebuild a named host |
| `just check` | `nix flake check` |
| `just fmt` / `just fmt-check` | alejandra over the tree |
| `just update` / `just update-input <i>` | flake inputs |
| `just validate` | rebuild inventory db and check it against the module tree |
| `just fetch-hwconfig <host>` | pull and stage a host's hardware config |
| `just gc` / `just gc-system` / `just diff` | maintenance |

## Adding a New Host

1. Create `modules/hosts/<hostname>/default.nix`:

```nix
{inputs, ...}: {
  flake.modules.nixos.<hostname> = {
    inputs,
    pkgs,
    ...
  }: {
    imports =
      [./_hardware-configuration.nix]
      ++ (with inputs.self.modules.nixos; [
        desktop # or system-cli for a headless box
        docker
        alucascu
        pki
        agenix
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "<hostname>";

    networking = {
      hostName = "<hostname>";
      networkmanager.enable = true;
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

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "<hostname>";
}
```

2. Put the machine's `hardware-configuration.nix` in the host directory as
   `_hardware-configuration.nix` — `just fetch-hwconfig <hostname>` does this
   over SSH and stages it.
3. `git add` the new files — `import-tree` picks them up automatically.
4. Add the host to `inventory/machines.toml` so `just validate` passes.
5. `sudo nixos-rebuild switch --flake .#<hostname>`

## Adding a Standalone Home Target

For a machine running Nix but not NixOS. There is no hardware config and no
`nixosConfiguration` — that is the whole difference from a host.

```nix
# modules/homes/<name>/default.nix
{inputs, ...}: {
  flake.modules.homeManager.<name> = {
    imports = with inputs.self.modules.homeManager; [
      core
      shell
      git
      neovim
      ssh
      terminal
      gnupg
    ];

    home = {
      username = "<user>";
      homeDirectory = "/home/<user>";
    };
  };

  flake.homeConfigurations = inputs.self.lib.mkHome "x86_64-linux" "<name>";
}
```

Apply with `home-manager switch --flake .#<name>`.

## Adding a New User

1. Create `modules/users/<username>.nix`:

```nix
{inputs, ...}: {
  flake.modules.nixos.<username> = {pkgs, ...}: {
    users.users.<username> = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel" "networkmanager" "docker"];
      openssh.authorizedKeys.keys = [];
    };

    home-manager.users.<username>.imports = [
      inputs.self.modules.homeManager.<username>
    ];
  };

  flake.modules.homeManager.<username> = {
    imports = with inputs.self.modules.homeManager; [
      core
      shell
      git
      neovim
      ssh
      gnupg
    ];

    home = {
      username = "<username>";
      homeDirectory = "/home/<username>";
    };
  };
}
```

2. Import the user aspect from the host: add `<username>` to the host's imports.

The user aspect carries **identity plus the CLI set only**. Anything graphical
belongs to the `desktop` profile, which the graphical hosts import and headless
hosts do not — that is what keeps a headless box from building a browser.

## Adding a New Home Module

Simple case — wraps a home-manager config as an aspect:

```nix
# modules/home/<name>.nix
{...}: {
  flake.modules.homeManager.<name> = {pkgs, ...}: {
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

Then add `<name>` to the user's homeManager aspect imports, or to the `desktop`
profile if it is graphical.

## Adding a New NixOS Service/Program

```nix
# modules/services/<name>.nix
{
  flake.modules.nixos.<name> = {
    services.<name>.enable = true;
  };
}
```

Then add `<name>` to the appropriate system-type, profile, or host imports. A
service that publishes a Caddy vhost must import the `caddy` aspect itself
rather than relying on another service to have enabled it.

## Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable |
| `home-manager` | follows nixpkgs (master branch) |
| `flake-parts` | module registry, flake output wiring |
| `import-tree` | recursive auto-import of `modules/` |
| `lazyvim` | LazyVim home-manager module (pfassina/lazyvim-nix) |
| `plasma-manager` | plasma-manager home-manager module (nix-community) |
| `globalprotect-openconnect` | GlobalProtect VPN client (yuezk) |
| `starttree` | StartTree browser start page (Paul-Houser), `flake = false` |
| `agenix` | age-encrypted secrets (ryantm) |
| `tagstudio` | TagStudio file tagging (TagStudioDev) |

## Important Rules

- Never import files that set `flake.modules.*` from within a NixOS/homeManager
  module — only import plain modules there.
- `imports` inside aspects must be unconditional — use `lib.mkMerge` +
  `lib.mkIf` for conditional config, never conditional imports.
- `pkgs` must be requested at the aspect (inner) function level, not the
  flake-parts (outer) level. Take arguments at the outer level only when the
  outer scope genuinely uses them (typically `inputs`).
- Internal files used by a feature must be prefixed with `_` to prevent
  `import-tree` from treating them as top-level feature modules. The prefix
  means *internal and used* — an unimported `_` file is dead code, not a draft.
- Always `git add` new files before rebuilding — Nix flakes only see
  staged/committed files.
- Run `just fmt` before committing. Generated `_hardware-configuration.nix`
  files are exempt; the exclusion lives in
  `modules/nix/flake-parts/formatter.nix`.
- The `nix.nix` settings file registers as aspect `nix-settings` (not `nix`) —
  used by `system-default`.
- Prefer `home-manager.sharedModules` over `home-manager.users.<name>` in
  anything that is not itself user-specific, so profiles stay username-agnostic.
