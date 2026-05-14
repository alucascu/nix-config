# Host Inventory Overview

Machine inventory is tracked in a TOML file with three relation tables: `pantheons`, `realms`, and `hosts`.
The foreign key chain is `hosts.realm` → `realms.pantheon` → `pantheons.type`.

---

## Pantheons

Pantheons define the **machine type**. Every realm belongs to a pantheon, which determines what
kind of infrastructure that realm represents.

| Pantheon | Type |
|---|---|
| greek | Physical machine |
| norse | VM |
| roman | Container |
| egyptian | Cloud |
| mesopotamian | Network device |

---

## Realms

Realms represent **physical or logical devices**. A realm belongs to a pantheon (and therefore a
type), carries hardware/ownership metadata, and can host multiple boot environments or OS installs.

| Realm | Pantheon | Type | Owner | Form Factor | Model / Hardware |
|---|---|---|---|---|---|
| erebus | greek | Physical | NCG | Laptop | HP Elitebook 8 G1i 14in |
| olympus | greek | Physical | NCG | Laptop | HP Elitebook 840 G11 |
| elysium | greek | Physical | Asher Lucas-Cuddeback | Mini-ITX | Ryzen 9 9900X3D, RTX 4070, 64GB RAM, 4TB |

---

## Hosts

Hosts represent **OS environments** — a specific operating system and configuration running on a
realm. Multiple hosts can share a realm (dual-boot, replaced OS). A host's full context is resolved
by walking up to its realm and then its pantheon.

| Host | Realm | Owner | OS | WM | Shell | User | Status |
|---|---|---|---|---|---|---|---|
| hades | erebus | NCG | NixOS | KDE | fish | alucascu | active |
| helios | erebus | NCG | Windows 11 | — | powershell | ncgmail/alucascuddeback | unprovisioned |
| hestia | olympus | NCG | CachyOS | Hyprland | zsh | asherl | active |
| diomedes | elysium | Asher Lucas-Cuddeback | Omarchy | Hyprland | bash | asher | active |

> **Note:** `helios` is unprovisioned — the OS has been wiped and awaits reinstall.

---

## Status Values

| Status | Meaning |
|---|---|
| active | In regular use |
| dormant | Functional but seldom used |
| unprovisioned | OS wiped, awaiting reinstall |
| decommissioned | Permanently out of service |

---

## Restic Backup Paths

Several hosts carry local and SSD-based restic backup paths. These are host-level fields:

- `restic_local` — path to the local restic repository on the host filesystem
- `restic_ssd` — path to the restic repository on an attached external SSD
