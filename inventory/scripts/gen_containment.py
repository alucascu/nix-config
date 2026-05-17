"""
gen_containment.py — generate a containment SVG diagram from the host inventory DB.

Usage
-----
    python gen_containment.py inventory.db [output.svg]

If no output path is given, writes to containment.svg in the current directory.
"""

import sqlite3
import sys
import textwrap
from dataclasses import dataclass, field
from pathlib import Path


# ── palette (light-mode hex; SVG is static so we bake values in) ──────────────
COLORS = {
    "pantheon_fill":   "#EEEDFE",  # purple-50
    "pantheon_stroke": "#534AB7",  # purple-600
    "pantheon_title":  "#3C3489",  # purple-800
    "realm_fill":      "#E1F5EE",  # teal-50
    "realm_stroke":    "#0F6E56",  # teal-600
    "realm_title":     "#085041",  # teal-800
    "realm_sub":       "#0F6E56",  # teal-600
    "hw_fill":         "#F1EFE8",  # gray-50
    "hw_stroke":       "#5F5E5A",  # gray-600
    "hw_text":         "#444441",  # gray-800
    "host_fill":       "#FAECE7",  # coral-50
    "host_stroke":     "#993C1D",  # coral-600
    "host_title":      "#712B13",  # coral-800
    "host_sub":        "#993C1D",  # coral-600
    "bg":              "#FFFFFF",
}

FONT = "system-ui, -apple-system, 'Segoe UI', sans-serif"

# ── layout constants ───────────────────────────────────────────────────────────
PAD_OUTER   = 32   # canvas edge padding
PAD_P       = 20   # padding inside pantheon box
PAD_R       = 16   # padding inside realm box
GAP_P       = 24   # vertical gap between pantheon boxes
GAP_R       = 14   # vertical gap between realm boxes inside a pantheon
GAP_H       = 10   # vertical gap between host chips inside a realm

PANTHEON_W  = 640  # fixed width for all pantheon containers (inside canvas padding)
REALM_W     = PANTHEON_W - 2 * PAD_P

HOST_H      = 44   # height of a single host chip
HOST_W      = (REALM_W - PAD_R * 2 - 10) // 2   # two columns of hosts
HW_H        = 36   # height of the hardware row

TITLE_H     = 22   # height reserved for pantheon/realm title row
SUB_H       = 16   # height for subtitle row


@dataclass
class HostRow:
    name: str
    os: str
    wm: str | None
    shell: str | None
    status: str


@dataclass
class RealmRow:
    name: str
    owner: str
    form_factor: str | None
    model: str | None
    hw: dict | None          # realm_hardware row or None
    hosts: list[HostRow] = field(default_factory=list)


@dataclass
class PantheonRow:
    name: str
    type_: str
    realms: list[RealmRow] = field(default_factory=list)


# ── DB helpers ─────────────────────────────────────────────────────────────────

def load_data(db_path: str) -> list[PantheonRow]:
    con = sqlite3.connect(db_path)
    con.row_factory = sqlite3.Row

    pantheons: dict[str, PantheonRow] = {}
    for row in con.execute("SELECT name, type FROM pantheons ORDER BY name"):
        pantheons[row["name"]] = PantheonRow(name=row["name"], type_=row["type"])

    realms: dict[str, RealmRow] = {}
    for row in con.execute(
        "SELECT r.name, r.pantheon, r.owner, r.form_factor, r.model, "
        "       h.cpu, h.ram_gb, h.gpu, h.storage_tb "
        "FROM realms r "
        "LEFT JOIN realm_hardware h ON h.realm = r.name "
        "ORDER BY r.pantheon, r.name"
    ):
        hw = None
        if row["cpu"] or row["ram_gb"] or row["gpu"] or row["storage_tb"]:
            hw = {
                "cpu": row["cpu"],
                "ram_gb": row["ram_gb"],
                "gpu": row["gpu"],
                "storage_tb": row["storage_tb"],
            }
        realm = RealmRow(
            name=row["name"],
            owner=row["owner"],
            form_factor=row["form_factor"],
            model=row["model"],
            hw=hw,
        )
        realms[row["name"]] = realm
        if row["pantheon"] in pantheons:
            pantheons[row["pantheon"]].realms.append(realm)

    for row in con.execute(
        "SELECT name, realm, os, wm, shell, status FROM hosts ORDER BY realm, name"
    ):
        if row["realm"] in realms:
            realms[row["realm"]].hosts.append(HostRow(
                name=row["name"],
                os=row["os"],
                wm=row["wm"],
                shell=row["shell"],
                status=row["status"],
            ))

    con.close()
    return [p for p in pantheons.values() if p.realms]  # skip empty pantheons


# ── height pre-calculation ────────────────────────────────────────────────────

def realm_inner_h(realm: RealmRow) -> int:
    """Height of realm box contents (title + hw row + host chips)."""
    h = PAD_R + TITLE_H + SUB_H + PAD_R  # title area
    if realm.hw:
        h += HW_H + GAP_H
    if realm.hosts:
        rows = (len(realm.hosts) + 1) // 2
        h += rows * HOST_H + (rows - 1) * GAP_H
    h += PAD_R
    return h


def pantheon_inner_h(pantheon: PantheonRow) -> int:
    h = PAD_P + TITLE_H + PAD_P // 2
    for i, realm in enumerate(pantheon.realms):
        h += realm_inner_h(realm)
        if i < len(pantheon.realms) - 1:
            h += GAP_R
    h += PAD_P
    return h


# ── SVG element builders ───────────────────────────────────────────────────────

def esc(s: str) -> str:
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def rect(x, y, w, h, rx=8, fill="none", stroke="none", sw=1.0, extra="") -> str:
    return (
        f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" '
        f'fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {extra}/>'
    )


def text(x, y, content, anchor="start", size=13, weight=400, color="#000",
         baseline="auto") -> str:
    return (
        f'<text x="{x}" y="{y}" text-anchor="{anchor}" '
        f'font-size="{size}" font-weight="{weight}" fill="{color}" '
        f'dominant-baseline="{baseline}">{esc(str(content))}</text>'
    )


# ── rendering passes ──────────────────────────────────────────────────────────

def render_hw(lines: list[str], realm: RealmRow, x: int, y: int, w: int) -> None:
    hw = realm.hw
    parts = []
    if hw.get("cpu"):
        parts.append(hw["cpu"])
    if hw.get("ram_gb"):
        parts.append(f'{hw["ram_gb"]} GB RAM')
    if hw.get("gpu"):
        parts.append(hw["gpu"])
    if hw.get("storage_tb"):
        parts.append(f'{hw["storage_tb"]} TB')
    hw_str = "  ·  ".join(parts)

    lines.append(rect(x, y, w, HW_H, rx=6,
                       fill=COLORS["hw_fill"], stroke=COLORS["hw_stroke"], sw=0.5))
    lines.append(text(x + 10, y + HW_H // 2, hw_str,
                       size=11, weight=400, color=COLORS["hw_text"],
                       baseline="central"))


def render_host_chip(lines: list[str], host: HostRow, x: int, y: int, w: int) -> None:
    lines.append(rect(x, y, w, HOST_H, rx=6,
                       fill=COLORS["host_fill"], stroke=COLORS["host_stroke"], sw=0.5))
    lines.append(text(x + 10, y + 14, host.name,
                       size=13, weight=500, color=COLORS["host_title"]))
    sub_parts = [host.os]
    if host.wm:
        sub_parts.append(host.wm)
    if host.shell:
        sub_parts.append(host.shell)
    lines.append(text(x + 10, y + 30, "  ·  ".join(sub_parts),
                       size=11, weight=400, color=COLORS["host_sub"]))


def render_realm(lines: list[str], realm: RealmRow,
                 x: int, y: int, w: int) -> int:
    """Render realm box; returns the box height."""
    h = realm_inner_h(realm)
    lines.append(rect(x, y, w, h, rx=10,
                       fill=COLORS["realm_fill"], stroke=COLORS["realm_stroke"], sw=0.8))

    cy = y + PAD_R
    lines.append(text(x + PAD_R, cy + TITLE_H // 2, realm.name,
                       size=14, weight=500, color=COLORS["realm_title"],
                       baseline="central"))
    cy += TITLE_H

    sub_parts = []
    if realm.form_factor:
        sub_parts.append(realm.form_factor)
    if realm.model:
        sub_parts.append(realm.model)
    if realm.owner:
        sub_parts.append(realm.owner)
    lines.append(text(x + PAD_R, cy + SUB_H // 2, "  ·  ".join(sub_parts),
                       size=11, weight=400, color=COLORS["realm_sub"],
                       baseline="central"))
    cy += SUB_H + PAD_R

    if realm.hw:
        render_hw(lines, realm, x + PAD_R, cy, w - 2 * PAD_R)
        cy += HW_H + GAP_H

    if realm.hosts:
        col_w = HOST_W
        for i, host in enumerate(realm.hosts):
            col = i % 2
            row = i // 2
            hx = x + PAD_R + col * (col_w + 10)
            hy = cy + row * (HOST_H + GAP_H)
            render_host_chip(lines, host, hx, hy, col_w)

    return h


def render_pantheon(lines: list[str], pantheon: PantheonRow,
                    x: int, y: int, w: int) -> int:
    h = pantheon_inner_h(pantheon)
    lines.append(rect(x, y, w, h, rx=14,
                       fill=COLORS["pantheon_fill"],
                       stroke=COLORS["pantheon_stroke"], sw=1.0))

    title = f"{pantheon.name}  —  {pantheon.type_}"
    lines.append(text(x + PAD_P, y + PAD_P + TITLE_H // 2, title,
                       size=15, weight=500, color=COLORS["pantheon_title"],
                       baseline="central"))

    cy = y + PAD_P + TITLE_H + PAD_P // 2
    for realm in pantheon.realms:
        rh = render_realm(lines, realm,
                          x + PAD_P, cy, w - 2 * PAD_P)
        cy += rh + GAP_R

    return h


# ── top-level SVG assembly ────────────────────────────────────────────────────

def generate_svg(pantheons: list[PantheonRow]) -> str:
    lines: list[str] = []
    canvas_w = PAD_OUTER * 2 + PANTHEON_W

    # calculate total height
    total_h = PAD_OUTER
    for p in pantheons:
        total_h += pantheon_inner_h(p) + GAP_P
    total_h += PAD_OUTER

    lines.append(
        f'<svg xmlns="http://www.w3.org/2000/svg" '
        f'width="{canvas_w}" height="{total_h}" '
        f'viewBox="0 0 {canvas_w} {total_h}" '
        f'font-family="{FONT}">'
    )
    lines.append(f'<rect width="{canvas_w}" height="{total_h}" fill="{COLORS["bg"]}"/>')

    cy = PAD_OUTER
    for pantheon in pantheons:
        ph = render_pantheon(lines, pantheon, PAD_OUTER, cy, PANTHEON_W)
        cy += ph + GAP_P

    lines.append("</svg>")
    return "\n".join(lines)


# ── entry point ───────────────────────────────────────────────────────────────

def main() -> None:
    if len(sys.argv) < 2:
        print("usage: python gen_containment.py <inventory.db> [output.svg]")
        sys.exit(1)

    db_path = sys.argv[1]
    out_path = sys.argv[2] if len(sys.argv) > 2 else "containment.svg"

    pantheons = load_data(db_path)
    svg = generate_svg(pantheons)
    Path(out_path).write_text(svg, encoding="utf-8")
    print(f"wrote {out_path}  ({len(pantheons)} pantheons)")


if __name__ == "__main__":
    main()
