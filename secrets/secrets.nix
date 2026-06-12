let
  hades = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINO3z2StZULhOzO2gmKJGLHpLjIBGKL3LNFhlPkZKRWv root@hades";
  odysseus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPogMWSjJAxiaBryiqK6YHFqMHT9gQlzttPGiIel4H9w root@odysseus";
  tantalus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3kI7sQXaeiBL5saaK4HPD44+wpX74WjqtpXmxTHmMs root@tantalus";

  alucascu_hades = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjientAZiNuoiwFV7bMdkNZB0j5qM+TsHGKwG2KXbO5 alucascu@hades";
  alucascu_odysseus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVLgoxrHCSzVI2X1hgL/cN+VYot2TA3N+cTe/9oL3os alucascu@proton.me";

  systems = [hades odysseus tantalus];
  users = [alucascu_hades alucascu_odysseus];
in {
  "vpn.age".publicKeys = systems ++ users;
  "freshrss-password.age".publicKeys = systems ++ users;
  "wireguard-hades.age".publicKeys = [hades alucascu_hades alucascu_odysseus];
  "wireguard-odysseus.age".publicKeys = [odysseus alucascu_odysseus alucascu_hades];
}
