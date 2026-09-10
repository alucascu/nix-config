{...}: {
  # Vendor firmware updates over LVFS (`fwupdmgr refresh && fwupdmgr update`).
  # All three machines are physical boxes with UEFI, so they all have BIOS, ME,
  # SSD and dock firmware that otherwise only ships through a Windows installer.
  flake.modules.nixos.fwupd = {
    services.fwupd.enable = true;
  };
}
