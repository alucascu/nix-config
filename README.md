# nixConfig

Personal NixOS + home-manager configuration.

Built on [`flake-parts`](https://flake.parts) and [`import-tree`](https://github.com/vic/import-tree) using a dendritic (tree-structured) module pattern. Every `.nix` file under `modules/` is auto-imported — adding a file is enough to register it. Files prefixed with `_` are internal to their parent feature and excluded from auto-import.

## Quick start

```bash
# Rebuild the current host (system + home-manager)
just rebuild

# Rebuild a specific host
just rebuild-host hades

# Check the flake evaluates cleanly
just check          # nix flake check

# After adding new files (Nix only sees git-tracked files)
git add <new-file> && just rebuild
```

Run `just` with no arguments to list every task. The raw commands work too:

```bash
sudo nixos-rebuild switch --flake .#hades
nix flake check
```

## Structure

```
├── flake.nix               # inputs + import-tree bootstrap only
├── justfile                # task runner (rebuild, check, inventory, provisioning)
├── inventory/              # machine fleet database (sqlite, generated from seed.sql)
├── secrets/                # agenix-encrypted secrets (.age) + secrets.nix
└── modules/
    ├── nix/flake-parts/    # mkNixos/mkHome helpers, flake-parts bootstrap
    ├── system/
    │   ├── settings/       # locale (America/Detroit), nix settings (allowUnfree, flakes)
    │   └── system-types/   # system-default → system-cli → system-desktop ladder
    ├── services/           # docker, pipewire, fprintd, globalprotect, restic
    ├── programs/           # desktop-kde (plasma6, sddm, printing), chromium, libreoffice
    ├── profiles/           # gaming, work — opt-in bundles of services/programs
    ├── home/               # core, shell, git, gnupg, ssh, terminal, plasma, browser, neovim
    ├── users/              # alucascu — NixOS account + home-manager wiring
    └── hosts/
        ├── hades/          # desktop host config + hardware-configuration
        └── odysseus/       # laptop host config + hardware-configuration
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
| `system-cli` | git, neovim, wget, tmux, just, `EDITOR=nvim` |
| `system-desktop` | desktop-kde, pipewire, pcscd |

**Profiles** are opt-in aspect bundles (e.g. `gaming`, `work`) that layer additional services and programs on top of a system type.

**Host `hades`** uses `system-desktop` + `docker` + `alucascu` (desktop).
**Host `odysseus`** uses `system-desktop` + `docker` + `gaming` + `alucascu` (laptop, nvidia).

## Inventory

`inventory/` tracks every machine in the fleet in a three-tier hierarchy
(`pantheon → realm → host`) with a mythological naming scheme. The source of
truth is `inventory/seed.sql`; `machines.db` and the inventory README are
derived from it.

```bash
just db          # rebuild machines.db from schema + seed
just validate    # validate inventory against the module tree
just query "select * from hosts"
```

## Secrets

Secrets live in `secrets/` and are encrypted with
[agenix](https://github.com/ryantm/agenix). Recipients and file→key mappings are
declared in `secrets/secrets.nix`; encrypted payloads are the `.age` files
(VPN config, WireGuard keys, FreshRSS password).

## Adding things

**New home module** — create `modules/home/<name>.nix`, then add `<name>` to the imports in `modules/users/alucascu.nix`.

**New NixOS service** — create `modules/services/<name>.nix`, then add `<name>` to the host, system-type, or profile imports.

**New profile** — create `modules/profiles/<name>.nix` as a NixOS aspect, then add `<name>` to whichever hosts need it.

**New host** — create `modules/hosts/<hostname>/default.nix` + `_hardware-configuration.nix` (use `just fetch-hwconfig <hostname>` to pull it from a remote host), then run `just rebuild-host <hostname>`. See [CLAUDE.md](CLAUDE.md) for the full template.

## Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable |
| `home-manager` | follows nixpkgs (master) |
| `flake-parts` | flake output wiring |
| `import-tree` | recursive module auto-import |
| `lazyvim` | LazyVim home-manager module |
| `plasma-manager` | KDE Plasma home-manager config |
| `globalprotect-openconnect` | GlobalProtect VPN client |
| `agenix` | age-encrypted secrets |
| `starttree` | StartTree browser start page |
| `tagstudio` | TagStudio file tagging app |

## Rules

- Never import a file that sets `flake.modules.*` from inside a NixOS/homeManager module.
- `imports` inside aspects must be unconditional — use `lib.mkMerge` + `lib.mkIf` for conditional config.
- Request `pkgs` at the inner (aspect) function level, not the flake-parts outer level.
- Always `git add` new files before rebuilding.
- Internal files must be prefixed with `_`.

For full reference including neovim setup and detailed how-to guides, see [CLAUDE.md](CLAUDE.md).
