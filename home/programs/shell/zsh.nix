{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.shell.zsh;
in {
  options.localHome.programs.shell.zsh = {
    enable = lib.mkEnableOption "zsh shell configuration";

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/nixconfig";
      description = "Fallback location of this flake when it can't be detected from $PWD.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      dirHashes = {
        docs = "$HOME/Documents/";
        nixconfig = cfg.flakePath;
      };

      sessionVariables.NIXCONFIG = cfg.flakePath;

      shellAliases = {
        ls = "eza --icons --group-directories-first";
        la = "eza -la --icons --group-directories-first";
        tree = "eza --tree --icons";
      };

      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.zsh_history";
      history.ignorePatterns = ["rm *" "pkill *" "cp *"];

      initContent = ''
        if [ -f "$HOME/.zprofile" ]; then
          source "$HOME/.zprofile"
        fi

        # Ported from pre-nix .zshrc; starship + direnv hooks are
        # injected by home-manager, so they are omitted here.
        [ -f "$HOME/.config/zshconfig/index.zsh" ] && source "$HOME/.config/zshconfig/index.zsh"

        # Prefer the repo we're standing in (e.g. a worktree or second clone),
        # but only if its flake.nix actually defines darwinConfigurations, so
        # running these inside an unrelated flake project doesn't build it.
        _nixconfig_root() {
          local root
          root=$(git rev-parse --show-toplevel 2>/dev/null)
          if [[ -n $root ]] && grep -qs darwinConfigurations "$root/flake.nix"; then
            print -r -- "$root"
          else
            print -r -- "''${NIXCONFIG:-${cfg.flakePath}}"
          fi
        }
        nixrebuild() { sudo darwin-rebuild switch --flake "$(_nixconfig_root)" "$@"; }
        switchhome() { home-manager switch --flake "$(_nixconfig_root)" "$@"; }
        nixupdate()  { nix flake update --flake "$(_nixconfig_root)" "$@"; }

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        # Appended, not prepended: Flutter bundles its own (older) Dart SDK, and
        # the Nix-managed `dart` in ~/.nix-profile/bin must win on PATH.
        export PATH="$PATH:$HOME/Dev/tooling/flutter/bin"

        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
        command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"

        # SDKMAN insists on being last.
        export SDKMAN_DIR="$HOME/.sdkman"
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
      '';
    };
  };
}
