INSERT INTO pantheons (name, type) VALUES
    ('norse', 'VM'),
    ('greek', 'Physical'),
    ('roman', 'Container'),
    ('egyptian', 'Cloud'),
    ('mesopotamian', 'Network');

INSERT INTO realms (name, pantheon, owner, status, form_factor, model) VALUES
    ('erebus', 'greek', 'NCG', 'active', 'laptop', 'HP Elitebook 8 G1i 14in'),
    ('olympus', 'greek', 'NCG', 'active', 'laptop', 'HP Elitebook 840 G11'),
    ('elysium', 'greek', 'Asher Lucas-Cuddeback', 'active', 'Mini-ITX', NULL),
    ('tartarus', 'greek', 'Asher Lucas-Cuddeback', 'active', 'ATX', NULL);

INSERT INTO realm_hardware (realm, cpu, ram_gb, gpu, storage_tb) VALUES
    ('elysium', 'AMD Ryzen 9 9900x3d', 64, 'Zotac RTX 4070 Twin Edge', 4),
    ('tartarus', 'AMD Ryzen 5 7600X', 32, 'MSI GAMING X Radeon RX 6600 XT 8 GB', 4);

INSERT INTO hosts (name, realm, owner, os, wm, shell, terminal_emulator, user, status, restic_local, restic_ssd) VALUES
    ('hades', 'erebus', NULL, 'NixOS', 'KDE', 'fish', 'kitty', 'alucascu', 'active', '/home/alucascu/.local/restic-repo/', '/run/media/alucascu/Extreme SSD/restic/'),
    ('hestia', 'elysium', NULL, 'CachyOS', 'hyprland', 'zsh', 'kitty', 'asherl', 'active', '/home/asherl/.local/restic-repo/', '/run/media/asherl/Extreme SSD/restic/'),
    ('helios', 'erebus', NULL, 'Windows 11', NULL, 'powershell', 'wezterm', 'ncgmail/alucascuddeback', 'unprovisioned', NULL, NULL),
    ('diomedes', 'elysium', NULL, 'Omarchy', 'hyprland', 'bash', 'kitty', 'asher', 'active', '/home/asher/.local/restic', '/run/media/asher/Extreme SSD/restic/'),
    ('odysseus', 'elysium', NULL, 'NixOS', 'KDE Plasma 6', 'fish', 'kitty', 'alucascu', 'active', NULL, NULL),
    ('tantalus', 'tartarus', NULL, 'NixOS', 'KDE Plasma 6', 'fish', 'kitty', 'alucascu', 'active', NULL, NULL);
