{...}: {
  # Intel thermal/power management daemon.
  #
  # On hades (HP EliteBook 8 G1i, Core Ultra 7 265H) hp-wmi fails to register a
  # platform profile — "hp_wmi: query 0x4 returned error 0x5", and no
  # /sys/firmware/acpi/platform_profile appears. power-profiles-daemon then
  # falls back to PlatformDriver "placeholder", so it can only nudge the
  # intel_pstate EPP hint and has no way to move the EC out of low-power mode.
  # The EC leaves the MMIO RAPL PL1 pinned at 17W against a 28W base power, and
  # since the hardware honours the lower of the MSR (40W) and MMIO limits, all
  # 16 cores sit around 1.2-1.9GHz under sustained load at ~70C — power capped,
  # not thermally capped.
  #
  # thermald drives the INT340X/DPTF interfaces directly (the
  # processor_thermal_* modules are already loaded) instead of leaving RAPL at
  # the firmware's floor.
  flake.modules.nixos.thermald = {
    services.thermald.enable = true;
  };
}
