import pathlib
import tomllib
from typing import Any

INVENTORY = pathlib.Path(__file__).parents[1]


def sql_val(v: Any) -> str:
    if v is None:
        return "NULL"
    if isinstance(v, bool):
        return "1" if v else "0"
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"


def row(*values: Any) -> str:
    return "(" + ", ".join(sql_val(v) for v in values) + ")"


def migrate(toml_path: pathlib.Path, output_path: pathlib.Path) -> None:
    with open(toml_path, "rb") as f:
        data = tomllib.load(f)

    blocks: list[str] = []

    # pantheons
    pantheon_rows = [
        row(name, attrs["type"]) for name, attrs in data.get("pantheons", {}).items()
    ]
    blocks.append(
        "INSERT INTO pantheons (name, type) VALUES\n    "
        + ",\n    ".join(pantheon_rows)
        + ";"
    )

    # realms — hardware is a nested subtable, strip it out before inserting
    realm_rows = []
    hardware_rows = []

    for name, attrs in data.get("realms", {}).items():
        hw = attrs.pop("hardware", None)
        realm_rows.append(
            row(
                name,
                attrs.get("pantheon"),
                attrs.get("owner"),
                attrs.get("status"),
                attrs.get("form_factor"),
                attrs.get("model"),
            )
        )
        if hw is not None:
            hardware_rows.append(
                row(
                    name,
                    hw.get("cpu"),
                    hw.get("ram_gb"),
                    hw.get("gpu"),
                    hw.get("storage_tb"),
                )
            )

    blocks.append(
        "INSERT INTO realms (name, pantheon, owner, status, form_factor, model) VALUES\n    "
        + ",\n    ".join(realm_rows)
        + ";"
    )

    if hardware_rows:
        blocks.append(
            "INSERT INTO realm_hardware (realm, cpu, ram_gb, gpu, storage_tb) VALUES\n    "
            + ",\n    ".join(hardware_rows)
            + ";"
        )

    # hosts
    host_rows = [
        row(
            name,
            attrs.get("realm"),
            attrs.get("owner"),
            attrs.get("os"),
            attrs.get("wm"),
            attrs.get("shell"),
            attrs.get("terminal_emulator"),
            attrs.get("user"),
            attrs.get("status"),
            attrs.get("restic_local"),
            attrs.get("restic_ssd"),
        )
        for name, attrs in data.get("hosts", {}).items()
    ]
    blocks.append(
        "INSERT INTO hosts (name, realm, owner, os, wm, shell, terminal_emulator, user, status, restic_local, restic_ssd) VALUES\n    "
        + ",\n    ".join(host_rows)
        + ";"
    )

    seed = "\n\n".join(blocks) + "\n"
    output_path.write_text(seed)
    print(f"wrote {output_path}")

    _warn_unknown_fields(data)


def _warn_unknown_fields(data: dict) -> None:
    known_host_fields = {
        "realm",
        "owner",
        "os",
        "wm",
        "shell",
        "terminal_emulator",
        "user",
        "status",
        "restic_local",
        "restic_ssd",
    }
    known_realm_fields = {"pantheon", "owner", "status", "form_factor", "model"}

    for name, attrs in data.get("hosts", {}).items():
        unknown = set(attrs) - known_host_fields
        if unknown:
            print(f"WARNING: host '{name}' has unmapped fields: {unknown}")

    for name, attrs in data.get("realms", {}).items():
        unknown = set(attrs) - known_realm_fields
        if unknown:
            print(f"WARNING: realm '{name}' has unmapped fields: {unknown}")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Migrate machines.toml to seed.sql")
    parser.add_argument(
        "toml", nargs="?", default=INVENTORY / "machines.toml", type=pathlib.Path
    )
    parser.add_argument("--output", "-o", default=INVENTORY / "seed.sql", type=pathlib.Path)
    args = parser.parse_args()

    migrate(args.toml, args.output)
