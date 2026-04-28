{inputs, ...}: {
  imports = [
    inputs.lazyvim.homeManagerModules.default
    ./modules/home
  ];
}
