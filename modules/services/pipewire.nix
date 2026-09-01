{...}: {
  flake.modules.nixos.pipewire = {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # Bluetooth headsets: sync AVRCP absolute volume with the sink volume,
      # and offer the wideband speech codecs. Roles are left at the default so
      # HFP/HSP stays available and headsets still autoswitch into call mode.
      #
      # suspend-timeout 0 stops WirePlumber suspending an idle A2DP sink after
      # 5s. Suspending releases the BlueZ media transport, and some headsets
      # (B&W Px8 S2) then refuse the re-acquire with NotAuthorized, leaving a
      # default sink that accepts streams and plays nothing.
      wireplumber.extraConfig."51-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-hw-volume" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-sbc-xq" = true;
        };
        "monitor.bluez.rules" = [
          {
            matches = [{"node.name" = "~bluez_output.*";}];
            actions.update-props."session.suspend-timeout-seconds" = 0;
          }
        ];
      };
    };
  };
}
