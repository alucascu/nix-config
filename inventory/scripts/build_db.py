import sqlite3
import pathlib

INVENTORY = pathlib.Path(__file__).parents[1]


def build(db_path: pathlib.Path = INVENTORY / "machines.db") -> None:
    db_path.unlink(missing_ok=True)
    con = sqlite3.connect(db_path)
    con.executescript((INVENTORY / "schema.sql").read_text())
    con.executescript((INVENTORY / "seed.sql").read_text())
    con.commit()
    con.close()


if __name__ == "__main__":
    build()
    print("machines.db rebuilt")
