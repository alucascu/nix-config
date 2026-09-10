{...}: {
  flake.modules.homeManager.nix-tools = {pkgs, ...}: {
    home.packages = with pkgs; [
      nix-output-monitor # readable build progress; nh uses it when present
      nvd # generation diffs -- backs `just diff`
      nix-tree # what is actually in this 8 GB closure
      nix-diff # why two derivations differ

      statix # anti-pattern lints -- backs `just lint`
      deadnix # unused binding/argument detection
    ];
  };
}
