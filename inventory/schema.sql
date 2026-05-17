PRAGMA foreign_keys = ON;

CREATE TABLE pantheons (
    name    TEXT PRIMARY KEY,
    type    TEXT NOT NULL CHECK(type IN ('Physical', 'VM', 'Container', 'Cloud', 'Network'))
);

CREATE TABLE realms (
    name        TEXT PRIMARY KEY,
    pantheon    TEXT NOT NULL REFERENCES pantheons(name),
    owner       TEXT NOT NULL,
    status      TEXT NOT NULL CHECK(status IN ('active', 'dormant', 'decommissioned')),
    form_factor TEXT,
    model       TEXT
);

CREATE TABLE realm_hardware (
    realm       TEXT PRIMARY KEY REFERENCES realms(name),
    cpu         TEXT,
    ram_gb      INTEGER,
    gpu         TEXT,
    storage_tb  REAL
);

CREATE TABLE hosts (
    name                TEXT PRIMARY KEY,
    realm               TEXT NOT NULL REFERENCES realms(name),
    owner               TEXT,
    os                  TEXT NOT NULL,
    wm                  TEXT,
    shell               TEXT,
    terminal_emulator   TEXT,
    user                TEXT,
    status              TEXT NOT NULL CHECK(status IN ('active', 'dormant', 'unprovisioned', 'decommissioned')),
    restic_local        TEXT,
    restic_ssd          TEXT
);
