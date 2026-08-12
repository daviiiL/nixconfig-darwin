{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.development.git;
in {
  options.localHome.programs.development.git.enable =
    lib.mkEnableOption "git with user identity and global ignores";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "David Liu";
        email = "davidas99017@gmail.com";
      };

      # Migrated from ~/.gitignore_global
      ignores = [
        # AI assistant prompt/context files
        "AGENTS.md"
        "CLAUDE.md"
        "GEMINI.md"

        # AI assistant directories
        ".aider/"
        ".claude/"
        ".claude/settings.local.json"
        ".cursor/"
        ".cursorignore"
        ".cursorrules"
        ".gemini/"
        ".gemini-clipboard/"
        ".codex/"
        ".opencode/"

        # AI session/transcript logs
        "*.jsonl"
        "*.log"
        ".aider.input.history"
        ".aider.chat.history.md"
        ".aider.tags.cache.v3"
        ".claude-history"
        "gemini-debug.log"

        # Specific AI-generated directories
        "docs/superpowers/"

        # Local development artifacts
        ".local/"
        ".sdkmanrc"

        # IDE / editor
        ".idea/"
      ];
    };
  };
}
