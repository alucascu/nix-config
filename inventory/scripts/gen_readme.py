"""
gen_readme.py — regenerate inventory/README.md with prose, live tables, and an
embedded containment SVG.

Runs the full pipeline:
  machines.toml → seed.sql → machines.db → containment.svg → README.md

Usage
-----
    python gen_readme.py          # from repo root or inventory/
    python gen_readme.py --check  # exit 1 if README would change (CI use)
"""

import argparse
import pathlib
import sqlite3
import sys

SCRIPTS = pathlib.Path(__file__).parent
INVENTORY = SCRIPTS.parent

README_PATH = INVENTORY / "README.md"

PANTHEON_DESCRIPTIONS = {
    "greek": (
        "Physical machines. Greek cosmology spans the full physical spectrum from the heights of "
        "Olympus to the depths of Tartarus — each realm a distinct, grounded domain. "
        "Realm names are drawn from Greek cosmological locations (Olympus, Erebus, Elysium, "
        "Tartarus …); host names are drawn from the gods and heroes who inhabit them."
    ),
    "norse": (
        "Virtual machines. The nine worlds of Norse cosmology hang from Yggdrasil, the world-tree. "
        "Each realm is a distinct but interconnected domain — a natural fit for VMs that share "
        "underlying hardware. Realm names come from the nine worlds (Asgard, Midgard, Jotunheim …); "
        "host names from the gods, heroes, and beings who dwell there."
    ),
    "roman": (
        "Containers. Roman gods mirror their Greek counterparts but carry a more civic, martial, "
        "and administrative character — appropriate for ephemeral workloads that serve a larger "
        "system. Realm names are the seven hills of Rome; host names are drawn from the Roman "
        "pantheon and their civic virtues."
    ),
    "egyptian": (
        "Cloud and remote instances. Egyptian mythology is structured around Ma'at (cosmic order) "
        "and the sun's nightly journey through the Duat. Well-suited for remote systems that are "
        "always running but seldom touched directly. Realm names come from sacred Egyptian places "
        "(Aaru, Duat, Iunu …); host names from gods of the solar cycle."
    ),
    "mesopotamian": (
        "Network devices. The oldest written mythology — Sumerian and Akkadian gods govern the "
        "fundamental forces of the world. Appropriate for the infrastructure that underpins "
        "everything else. Realm names are the first cities and cosmic regions (Eridu, Dilmun, "
        "Kur …); host names from the primordial gods and heroes."
    ),
}

STATUS_DESCRIPTIONS = {
    "active":          "In regular use.",
    "dormant":         "Functional but seldom used.",
    "unprovisioned":   "OS wiped or never installed; awaiting provisioning.",
    "decommissioned":  "Permanently out of service.",
}


# ── pipeline ──────────────────────────────────────────────────────────────────

def _run_pipeline() -> str:
    """Run migrate → build → gen_containment; return SVG text."""
    import importlib.util

    def load(name: str):
        spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        return mod

    migrate_toml = load("migrate_toml")
    build_db     = load("build_db")
    gen_svg      = load("gen_containment")

    migrate_toml.migrate(INVENTORY / "machines.toml", INVENTORY / "seed.sql")
    build_db.build(INVENTORY / "machines.db")

    pantheons = gen_svg.load_data(str(INVENTORY / "machines.db"))
    return gen_svg.generate_svg(pantheons)


# ── DB queries ────────────────────────────────────────────────────────────────

def _query(db: sqlite3.Connection, sql: str, *params) -> list[sqlite3.Row]:
    db.row_factory = sqlite3.Row
    return db.execute(sql, params).fetchall()


def _load_tables(db_path: pathlib.Path):
    con = sqlite3.connect(db_path)
    con.row_factory = sqlite3.Row

    pantheons = con.execute("SELECT name, type FROM pantheons ORDER BY name").fetchall()

    realms = con.execute(
        "SELECT r.name, r.pantheon, r.owner, r.status, r.form_factor, r.model, "
        "       h.cpu, h.ram_gb, h.gpu, h.storage_tb "
        "FROM realms r "
        "LEFT JOIN realm_hardware h ON h.realm = r.name "
        "ORDER BY r.pantheon, r.name"
    ).fetchall()

    hosts = con.execute(
        "SELECT name, realm, os, wm, shell, terminal_emulator, user, status, "
        "       restic_local, restic_ssd "
        "FROM hosts ORDER BY realm, name"
    ).fetchall()

    con.close()
    return pantheons, realms, hosts


# ── markdown helpers ──────────────────────────────────────────────────────────

def _row(*cells: str) -> str:
    return "| " + " | ".join(str(c) if c else "—" for c in cells) + " |"


def _header(*cols: str) -> str:
    return _row(*cols) + "\n" + _row(*("---" for _ in cols))


def _section(title: str, body: str, level: int = 2) -> str:
    hashes = "#" * level
    return f"{hashes} {title}\n\n{body.strip()}\n"


# ── README assembly ───────────────────────────────────────────────────────────

def _build_readme(svg: str, db_path: pathlib.Path) -> str:
    pantheons, realms, hosts = _load_tables(db_path)

    parts: list[str] = []

    parts.append(
        "<!-- AUTO-GENERATED — do not edit by hand; "
        "run `python inventory/scripts/gen_readme.py` -->\n"
        "# Inventory\n"
    )

    # ── introduction ──────────────────────────────────────────────────────────
    parts.append(
        "This directory tracks every machine in the fleet. "
        "The source of truth is `machines.toml`; everything else — "
        "`seed.sql`, `machines.db`, and this README — is derived from it "
        "by the scripts in `scripts/`.\n\n"
        "Machines are organised in a three-tier hierarchy:\n\n"
        "```\n"
        "pantheon  →  realm  →  host\n"
        "  (type)     (device)   (OS environment)\n"
        "```\n\n"
        "Names follow a mythological scheme described in `hostnames.md`. "
        "Each pantheon corresponds to a machine type and draws its realm and "
        "host names from a different mythology.\n"
    )

    # ── pantheons ─────────────────────────────────────────────────────────────
    pantheon_table = _header("Pantheon", "Type", "Description") + "\n"
    for p in pantheons:
        desc = PANTHEON_DESCRIPTIONS.get(p["name"], "")
        pantheon_table += _row(p["name"], p["type"], desc) + "\n"

    parts.append(
        _section(
            "Pantheons",
            "A **pantheon** defines the machine type. Every realm belongs to a pantheon, "
            "which determines what kind of infrastructure that realm represents. "
            "The name of each pantheon also fixes the mythological pool from which "
            "realm and host names are drawn.\n\n" + pantheon_table,
        )
    )

    # ── realms ────────────────────────────────────────────────────────────────
    realm_table = _header("Realm", "Pantheon", "Owner", "Form Factor", "Hardware", "Status") + "\n"
    for r in realms:
        hw_parts = []
        if r["cpu"]:         hw_parts.append(r["cpu"])
        if r["ram_gb"]:      hw_parts.append(f'{r["ram_gb"]} GB RAM')
        if r["gpu"]:         hw_parts.append(r["gpu"])
        if r["storage_tb"]:  hw_parts.append(f'{r["storage_tb"]} TB')
        hw = "  ·  ".join(hw_parts) if hw_parts else (r["model"] or "—")
        realm_table += _row(r["name"], r["pantheon"], r["owner"],
                            r["form_factor"], hw, r["status"]) + "\n"

    parts.append(
        _section(
            "Realms",
            "A **realm** represents a physical or logical device. "
            "It belongs to a pantheon (and therefore a type), carries hardware and "
            "ownership metadata, and can host one or more OS environments. "
            "The realm name comes from a location within its pantheon's mythology — "
            "for example, `erebus` and `elysium` are both locations in the Greek underworld, "
            "housed under the `greek` (physical) pantheon.\n\n" + realm_table,
        )
    )

    # ── hosts ─────────────────────────────────────────────────────────────────
    host_table = _header("Host", "Realm", "OS", "WM", "Shell", "User", "Status") + "\n"
    for h in hosts:
        host_table += _row(h["name"], h["realm"], h["os"],
                           h["wm"], h["shell"], h["user"], h["status"]) + "\n"

    # collect any notable notes
    notes = []
    for h in hosts:
        if h["status"] == "unprovisioned":
            notes.append(f"> **`{h['name']}`** is unprovisioned — the OS has been wiped and awaits reinstall.")

    notes_block = ("\n\n" + "\n".join(notes)) if notes else ""

    parts.append(
        _section(
            "Hosts",
            "A **host** represents a specific OS environment running on a realm. "
            "Multiple hosts can share a realm (dual-boot, replaced installs). "
            "A host's full context is resolved by walking up to its realm and then its pantheon. "
            "Host names are drawn from the gods, heroes, or beings native to their realm's "
            "mythology — so `hades` lives on `erebus` (Greek underworld) under the `greek` "
            "pantheon, and `odysseus` lives on `elysium` (Greek paradise) under the same.\n\n"
            + host_table + notes_block,
        )
    )

    # ── restic backup paths ───────────────────────────────────────────────────
    backup_hosts = [h for h in hosts if h["restic_local"] or h["restic_ssd"]]
    if backup_hosts:
        backup_table = _header("Host", "Local repo", "SSD repo") + "\n"
        for h in backup_hosts:
            backup_table += _row(h["name"],
                                 h["restic_local"] or "—",
                                 h["restic_ssd"]   or "—") + "\n"

        parts.append(
            _section(
                "Restic Backup Paths",
                "Hosts that carry restic backup configuration. "
                "`restic_local` is a repository on the host's own filesystem; "
                "`restic_ssd` is a repository on an attached external SSD.\n\n"
                + backup_table,
            )
        )

    # ── status reference ──────────────────────────────────────────────────────
    status_table = _header("Status", "Meaning") + "\n"
    for status, desc in STATUS_DESCRIPTIONS.items():
        status_table += _row(status, desc) + "\n"

    parts.append(_section("Status Values", status_table))

    # ── containment diagram ───────────────────────────────────────────────────
    parts.append(
        _section(
            "Containment Diagram",
            "Auto-generated from `machines.db` by `scripts/gen_containment.py`. "
            "Shows the full pantheon → realm → host hierarchy at a glance.\n\n" + svg,
        )
    )

    return "\n".join(parts)


# ── entry point ───────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true",
                        help="Exit 1 if README.md would change without writing it")
    args = parser.parse_args()

    svg = _run_pipeline()
    content = _build_readme(svg, INVENTORY / "machines.db")

    if args.check:
        current = README_PATH.read_text() if README_PATH.exists() else ""
        if current != content:
            print("inventory/README.md is out of date — run gen_readme.py", file=sys.stderr)
            sys.exit(1)
        print("inventory/README.md is up to date")
        return

    README_PATH.write_text(content)
    print(f"wrote {README_PATH}")


if __name__ == "__main__":
    main()
