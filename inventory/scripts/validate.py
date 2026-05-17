import sqlite3
import pathlib
import sys

REPO = pathlib.Path(__file__).parents[2]
DB = REPO / "inventory" / "machines.db"


def check_nixos_host_modules(con: sqlite3.Connection) -> list[str]:
    rows = con.execute(
        "SELECT name FROM hosts WHERE os = 'NixOS' AND status = 'active'"
    ).fetchall()
    errors = []
    for (name,) in rows:
        module = REPO / "modules" / "hosts" / name / "default.nix"
        if not module.exists():
            errors.append(f"active NixOS host '{name}' has no module at {module}")
    return errors


def check_host_realms(con: sqlite3.Connection) -> list[str]:
    rows = con.execute(
        "SELECT h.name, h.realm FROM hosts h"
        " LEFT JOIN realms r ON h.realm = r.name"
        " WHERE r.name IS NULL"
    ).fetchall()
    return [
        f"host '{name}' references unknown realm '{realm}'"
        for name, realm in rows
    ]


def run() -> None:
    con = sqlite3.connect(DB)
    errors = check_nixos_host_modules(con) + check_host_realms(con)
    con.close()
    if errors:
        for e in errors:
            print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)
    print("inventory valid")


if __name__ == "__main__":
    run()
