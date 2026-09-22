{
  flake.modules.homeManager.vscode = {pkgs, ...}: {
    programs.vscode = {
      enable = true;

      package = (pkgs.vscode.override {commandLineArgs = "--password-store=kwallet6";}).fhs;
    };
  };
}
