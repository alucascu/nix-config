{...}: {
  # ~1.0 GB. The extra's tools declare dotnet-sdk as a runtime dependency,
  # but that resolves to the nixpkgs default SDK; pin 8 explicitly instead.
  flake.modules.homeManager.neovim-dotnet = {
    key = "neovim-dotnet";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.dotnet = {
          enable = true;
          installDependencies = true; # fsautocomplete, csharpier, netcoredbg, fantomas
        };

        programs.lazyvim.extraPackages = [pkgs.dotnet-sdk_8];
      })
    ];
  };
}
