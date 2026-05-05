{inputs, ...}: {
  flake.modules.homeManager.plasma = {...}: {
    imports = [inputs.plasma-manager.homeModules.plasma-manager];

    programs.plasma.configFile = {
      "kitty.desktop"."_launch" = {
        value = "Meta+Return";
        shellExpand = false;
      };
    };
  };
}
