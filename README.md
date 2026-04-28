# nixConfig

Personal NixOS + home-manager configuration.

Built on [`flake-parts`](https://flake.parts) and [`import-tree`](https://github.com/divnix/import-tree) using a dendritic (tree-structured) module pattern. Every `.nix` file under `modules/` is auto-imported — adding a file is enough to register it. Files prefixed with `_` are internal to their parent feature and excluded from auto-import.

## Quick start

```bash
# Rebuild system + home-manager
sudo nixos-rebuild switch --flake .#hades

# Check flake evaluates cleanly
nix flake check

# After adding new files (Nix only sees git-tracked files)
git add <new-file> && sudo nixos-rebuild switch --flake .#hades
```

## Structure

```
modules/
├── nix/flake-parts/    # mkNixos helper, flake-parts bootstrap
├── system/
│   ├── settings/       # locale (America/Detroit), nix settings (allowUnfree, flakes)
│   └── system-types/   # system-default → system-cli → system-desktop inheritance ladder
├── services/           # docker, pipewire
├── programs/           # desktop-kde (plasma6, sddm, firefox)
├── home/               # core, shell, git, ssh, terminal, neovim
├── users/              # alucascu — NixOS account + home-manager wiring
└── hosts/hades/        # host config + hardware-configuration
```

## Key concepts

**Aspects** are named config fragments registered under:
- `flake.modules.nixos.<name>` — NixOS system config
- `flake.modules.homeManager.<name>` — home-manager user config

They are consumed via `inputs.self.modules.<class>.<name>` inside `imports` lists.

**System types** form an inheritance ladder — each host picks the right level:

| Type | Adds |
|---|---|
| `system-default` | nix-settings, locale, dbus-broker, bluetooth, nix-ld |
| `system-cli` | git, neovim, wget, tmux, `EDITOR=nvim` |
| `system-desktop` | desktop-kde, pipewire |

**Host `hades`** uses `system-desktop` + `docker` + `alucascu`.

## Adding things

**New home module** — create `modules/home/<name>.nix`, then add `<name>` to the imports in `modules/users/alucascu.nix`.

**New NixOS service** — create `modules/services/<name>.nix`, then add `<name>` to the host or system-type imports.

**New host** — create `modules/hosts/<hostname>/default.nix` + `_hardware-configuration.nix`, then run `sudo nixos-rebuild switch --flake .#<hostname>`. See [CLAUDE.md](CLAUDE.md) for the full template.

## Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable |
| `home-manager` | follows nixpkgs |
| `flake-parts` | flake output wiring |
| `import-tree` | recursive module auto-import |
| `lazyvim` | LazyVim home-manager module |

## Rules

- Never import a file that sets `flake.modules.*` from inside a NixOS/homeManager module.
- `imports` inside aspects must be unconditional — use `lib.mkMerge` + `lib.mkIf` for conditional config.
- Request `pkgs` at the inner (aspect) function level, not the flake-parts outer level.
- Always `git add` new files before rebuilding.
- Internal files must be prefixed with `_`.

For full reference including neovim setup and detailed how-to guides, see [OVERVIEW.md](OVERVIEW.md).
