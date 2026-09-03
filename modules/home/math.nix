{
  flake.modules.homeManager.math = {pkgs, ...}: {
    # sage's testsuite is a separate derivation that takes ~1h to realise and
    # gates nothing we build; sagelib already sets doCheck = false.
    home.packages = [(pkgs.sage.override {requireSageTests = false;})];
  };
}
