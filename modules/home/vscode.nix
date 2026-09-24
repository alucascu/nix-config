{
  flake.modules.homeManager.vscode = {
    pkgs,
    lib,
    inputs,
    ...
  }: let
    nixpkgsExt = pkgs.vscode-extensions;
    marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
    lsp = import ./_lsp-settings.nix {inherit lib pkgs;};

    # VSCode settings are flat dotted keys: { a.b = 1; } -> { "prefix.a.b" = 1; }
    flatten = prefix:
      lib.concatMapAttrs (name: value: let
        key = "${prefix}.${name}";
      in
        if lib.isAttrs value
        then flatten key value
        else {${key} = value;});

    shared = {
      extensions =
        (with nixpkgsExt; [
          jdinhlife.gruvbox
          ms-python.python
          ms-vsliveshare.vsliveshare
          mkhl.direnv
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          charliermarsh.ruff
          yzhang.markdown-all-in-one
          tamasfe.even-better-toml
        ])
        ++ (with marketplace; [
          meta.pyrefly
          asvetliakov.vscode-neovim
        ]);
      userSettings =
        {
          "workbench.colorTheme" = "Gruvbox Dark Medium";

          # LazyVim's editor defaults, and kitty's font.
          "editor.lineNumbers" = "relative";
          "editor.cursorSurroundingLines" = 4;
          "editor.formatOnSave" = true;
          "editor.fontFamily" = "'Lilex Nerd Font', monospace";

          "extensions.experimental.affinity"."asvetliakov.vscode-neovim" = 1;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = lib.getExe pkgs.nixd;
          "nix.serverSettings".nixd = lsp.nixd;
          "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
          "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
        }
        // flatten "python.pyrefly" lsp.pyrefly;
    };

    profiles = {
      default = {};

      rust = {
        extensions = with nixpkgsExt; [
          rust-lang.rust-analyzer
        ];
        userSettings = flatten "rust-analyzer" lsp.rust-analyzer;
      };

      ocaml = {
        extensions = with nixpkgsExt; [ocamllabs.ocaml-platform];
      };
    };
  in {
    programs.vscode = {
      enable = true;

      package = (pkgs.vscode.override {commandLineArgs = "--password-store=kwallet6";}).fhs;

      profiles = lib.mapAttrs (_: profile: lib.mkMerge [shared profile]) profiles;
    };
  };
}
