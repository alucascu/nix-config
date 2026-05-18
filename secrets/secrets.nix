let
  # Host SSH keys (used for system-level decryption at activation)
  hades = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINO3z2StZULhOzO2gmKJGLHpLjIBGKL3LNFhlPkZKRWv root@hades";

  alucascu_hades = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjientAZiNuoiwFV7bMdkNZB0j5qM+TsHGKwG2KXbO5 alucascu@hades";

  systems = [hades];
  users = [alucascu_hades];
in {
  "vpn.age".publicKeys = systems ++ users;
}
