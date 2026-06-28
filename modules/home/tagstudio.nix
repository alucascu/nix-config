{inputs, ...}: {
  flake.modules.homeManager.tagstudio = {pkgs, ...}: {
    home.packages = [
      (inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio.overrideAttrs (_: {
        dontCheckRuntimeDeps = true;
        doCheck = false;
        doInstallCheck = false;
      }))
    ];
  };
}
