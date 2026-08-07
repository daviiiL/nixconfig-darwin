{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.shell.zsh;
in {
  options.localHome.programs.shell.zsh.enable =
    lib.mkEnableOption "zsh shell configuration";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      dirHashes = {
        docs = "$HOME/Documents/";
        nixconfig = "$HOME/.config/nixconfig/";
      };

      shellAliases = {
        ls = "eza --icons --group-directories-first";
        la = "eza -la --icons --group-directories-first";
        tree = "eza --tree --icons";
        nixrebuild = "sudo darwin-rebuild switch --flake $HOME/.config/nixconfig";
        switchhome = "home-manager switch --flake $HOME/.config/nixconfig";
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

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        export PATH="$HOME/Dev/tooling/flutter/bin:$PATH"

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
