{
  # Defaults: SIGTERM the largest process below 10% free memory, SIGKILL below
  # 5%. freeSwapThreshold is live on hades, inert on the swapless hosts.
  flake.modules.nixos.earlyoom = {
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
    };
  };
}
