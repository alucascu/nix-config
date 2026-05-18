{
  flake.modules.nixos.printing = {
    services = {
      printing = {
        enable = true;
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    hardware = {
      printers = {
        ensureDefaultPrinter = "Brother-L2750";
        ensurePrinters = [
          {
            name = "Brother-L2750";
            location = "Local";
            deviceUri = "ipp://10.50.30.30/ipp/print";
            model = "everywhere";
          }
        ];
      };
    };
  };
}
