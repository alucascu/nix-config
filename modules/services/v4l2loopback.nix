{
  flake.modules.nixos.v4l2loopback = {config, ...}: {
    boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };
}
