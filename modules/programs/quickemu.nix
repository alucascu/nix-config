{
  flake.modules.nixos.quickemu = {pkgs, ...}: {
    environment.systemPackages = [pkgs.quickemu];

    # A Windows guest running WSL2 is running Hyper-V, so it needs SVM/VMX of
    # its own. quickemu boots Windows with `-cpu host`, which only carries the
    # virtualisation flag through when the host's kvm module permits nesting.
    # nested=1 is already the kernel default for both vendors -- stating it
    # keeps a default flip from quietly breaking WSL2 inside the guest. Both
    # are listed so the aspect stays portable: modprobe ignores options for a
    # module that never loads.
    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm_intel nested=1
    '';

    # Setuid spice-client-glib-usb-acl-helper, so handing a USB device to a
    # running guest from the SPICE viewer does not need a chown of the
    # /dev/bus/usb node every boot. nixpkgs' quickemu deliberately suffixes its
    # own spice-gtk onto PATH so this wrapped copy is the one found. The
    # tradeoff is that any local user can then claim any USB device.
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
