default:
    @just --list

# ── NixOS ─────────────────────────────────────────────────────────────────────

# nh wraps nixos-rebuild: nom progress output, an nvd diff of what changed, and
# it elevates itself, so none of these want a leading sudo.

# Rebuild and switch the current host
rebuild:
    nh os switch .

# Rebuild a specific host
rebuild-host hostname:
    nh os switch . --hostname {{hostname}}

# Build a host without activating it or leaving a ./result behind
build hostname:
    nh os build . --hostname {{hostname}}

# Print what a switch would do, without doing it
dry:
    nh os switch . --dry

# Stage the new configuration as the boot default, activating nothing now
boot:
    nh os boot .

# Return to the previous system generation
rollback:
    nh os rollback

# Build here, activate there -- the target's own hostname picks the config
deploy hostname:
    nh os switch . --target-host {{hostname}}

# Open a repl with a host's evaluated configuration in scope
repl hostname:
    nix repl .#nixosConfigurations.{{hostname}}

# Build every host and home target (see modules/nix/flake-parts/checks.nix)
check:
    nix flake check -L

# Format all nix files (generated hardware configs are exempt)
fmt:
    nix fmt

# Check formatting without writing
fmt-check:
    nix fmt -- --check

# Update all flake inputs
update:
    nix flake update

# Update a single input
update-input input:
    nix flake update {{input}}

# Update every input and commit the resulting lockfile
up:
    nix flake update
    git add flake.lock
    git diff --cached --quiet || git commit -m "chore(flake): update inputs"

# Lint the tree: anti-patterns, then dead code
lint:
    statix check .
    deadnix --fail --exclude .direnv modules/hosts/*/_hardware-configuration.nix

# Point this repo's git at the local commit template
commit-template:
    git config --local commit.template .gitmessage
    @echo "commit.template set to .gitmessage for this repo"

# ── Inventory ─────────────────────────────────────────────────────────────────

# Rebuild machines.db from schema + seed
db:
    python inventory/scripts/build_db.py

# Validate inventory against module tree
validate: db
    python inventory/scripts/validate.py

# Ad-hoc SQL query against the inventory
query q:
    sqlite3 -column -header inventory/machines.db {{q}}

# ── Host provisioning ─────────────────────────────────────────────────────────

# Pull hardware-configuration from a remote host and stage it
fetch-hwconfig hostname host=hostname:
    ssh {{host}} "nixos-generate-config --show-hardware-config" \
        > modules/hosts/{{hostname}}/_hardware-configuration.nix
    git add modules/hosts/{{hostname}}/_hardware-configuration.nix
    @echo "Staged _hardware-configuration.nix for {{hostname}}"

# ── Maintenance ───────────────────────────────────────────────────────────────

# Garbage collect this user's profiles, keeping a floor of 5 generations
gc:
    nh clean user --keep 5 --keep-since 14d

# Same, for every profile on the machine including the system one
gc-system:
    nh clean all --keep 5 --keep-since 14d

# Show what changed between the last two system generations
diff:
    #!/usr/bin/env bash
    set -euo pipefail
    nvd diff $(ls -d /nix/var/nix/profiles/system-*-link | sort -t- -k2 -n | tail -2)

# ── Secrets ───────────────────────────────────────────────────────────────────

# Re-encrypt every secret to the current recipient list in secrets/secrets.nix
rekey:
    cd secrets && agenix -r
