{...}: {
  flake.modules.homeManager.claude-code = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = [
      (pkgs.claude-code.override {
        manifest = lib.importJSON ./_manifest.json;
      })
    ];

    # Two accounts, told apart by CLAUDE_CONFIG_DIR: unset is the personal one
    # in ~/.claude, set is the work one in ~/.claude-work. Each directory holds
    # its own login, settings and history. The switch is per shell (-g, not
    # -U), so every new shell starts on personal.
    programs.fish.functions.claude-account = {
      description = "Switch this shell's Claude Code account: personal | work";
      body = ''
        switch "$argv[1]"
            case personal
                set -e CLAUDE_CONFIG_DIR
            case work
                set -gx CLAUDE_CONFIG_DIR ~/.claude-work
            case ""
            case '*'
                echo "usage: claude-account [personal|work]" >&2
                return 1
        end
        if set -q CLAUDE_CONFIG_DIR
            echo "claude: work ($CLAUDE_CONFIG_DIR)"
        else
            echo "claude: personal (~/.claude)"
        end
      '';
    };

    # Shown by `$env_var` in the shell aspect's right_format, only while set.
    programs.starship.settings.env_var.CLAUDE_CONFIG_DIR = {
      format = "[󰚩 work]($style) ";
      style = "bold orange";
    };
  };
}
