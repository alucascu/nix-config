default:
    @just --list

# ── NixOS ─────────────────────────────────────────────────────────────────────

# Rebuild and switch the current host
rebuild:
    sudo nixos-rebuild switch --flake .#$(hostname)

# Rebuild a specific host
rebuild-host hostname:
    sudo nixos-rebuild switch --flake .#{{hostname}}

# Check flake evaluates cleanly
check:
    nix flake check

# Update all flake inputs
update:
    nix flake update

# Update a single input
update-input input:
    nix flake update {{input}}

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

# Garbage collect (7-day retention)
gc:
    nix-collect-garbage --delete-older-than 7d

# Garbage collect system profiles too (requires sudo)
gc-system:
    sudo nix-collect-garbage --delete-older-than 7d

# Show what changed between the last two system generations
diff:
    nix store diff-closures /nix/var/nix/profiles/system-{$(ls /nix/var/nix/profiles/ | grep '^system-' | sort -t- -k2 -n | tail -2 | head -1 | cut -d- -f2),$(ls /nix/var/nix/profiles/ | grep '^system-' | sort -t- -k2 -n | tail -1 | cut -d- -f2)}-link
