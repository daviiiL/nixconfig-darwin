{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.shell.starship;

  zsh-transient-prompt = pkgs.fetchFromGitHub {
    owner = "olets";
    repo = "zsh-transient-prompt";
    rev = "v1.0.1";
    hash = "sha256-v4RuB/LL5/6d0FPDPrheFN5o1ZXKjIbfThz/sKSEuII=";
  };
in {
  options.localHome.programs.shell.starship.enable =
    lib.mkEnableOption "starship prompt";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        format = "$username$hostname$directory$git_branch$git_status$nodejs$bun$deno$python$rust$golang$java$docker_context$package$character";

        character = {
          success_symbol = "% ";
          error_symbol = "% ";
        };

        directory = {
          truncation_length = 6;
          truncate_to_repo = false;
          style = "bold 208";
          format = "[$path](bold 208) ";
          home_symbol = "~";
          truncation_symbol = "…/";
        };

        git_branch = {
          format = "[$branch](bold purple)";
          style = "bold purple";
        };

        git_status = {
          format = "[$all_status](bold purple)";
          style = "bold purple";
        };

        nodejs = {
          format = " via [$symbol$version](bold cyan) ";
          symbol = "⬢ ";
        };

        bun = {
          format = " via [$symbol$version](bold orange)";
          symbol = "🍞 ";
        };

        deno = {
          format = " via [$symbol$version](bold green)";
          symbol = "🦖 ";
        };

        python = {
          format = " via [$symbol$version](bold yellow)";
          symbol = "🐍 ";
        };

        rust = {
          format = " via [$symbol$version](bold red)";
          symbol = "🦀 ";
        };

        golang = {
          format = " via [$symbol$version](bold cyan)";
          symbol = "🐹 ";
        };

        java = {
          format = " via [$symbol$version](bold red)";
          symbol = "☕ ";
        };

        docker_context = {
          format = " via [$symbol$context](bold blue)";
          symbol = "🐳 ";
        };

        package = {
          format = " via [$symbol$version](bold 208)";
          symbol = "📦 ";
        };
      };
    };

    programs.zsh.initContent = lib.mkOrder 2500 ''
      TRANSIENT_PROMPT_TRANSIENT_PROMPT='%# '
      TRANSIENT_PROMPT_TRANSIENT_RPROMPT=""
      source ${zsh-transient-prompt}/transient-prompt.plugin.zsh
    '';
  };
}
