{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;

      # 47984/47989/47990/48010 TCP + 47998-48000/48002/48010 UDP, derived
      # from the base port by the upstream module.
      openFirewall = true;

      # Plasma runs Wayland here, so there is no X11 root window to grab and
      # Sunshine falls back to KMS capture -- which needs CAP_SYS_ADMIN to
      # open the DRM device as a non-master client.
      capSysAdmin = true;
    };

    # `settings` and `applications` are deliberately left unset: populating
    # either renders a config file and makes the web UI at
    # https://localhost:47990 read-only. Pairing, credentials and per-app
    # tweaks live in Sunshine's own state dir instead.
  };
}
