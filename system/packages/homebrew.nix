{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.localSystem.packages.homebrew;
in {
  options.localSystem.packages.homebrew = {
    enable = lib.mkEnableOption "Homebrew (installed by nix-homebrew, packages managed by nix-darwin)";

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["teamookla/speedtest/speedtest"];
      description = "Formulae to install. Use fully-qualified names for non-official taps.";
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["raycast"];
      description = ''
        Casks to install. Apps already present in /Applications from a manual
        install must first be adopted once with `brew install --cask --adopt <name>`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Installs the Homebrew prefix itself (/opt/homebrew) from a pinned source.
    nix-homebrew = {
      enable = true;
      user = config.system.primaryUser;
      enableRosetta = false;
      mutableTaps = false;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "teamookla/homebrew-speedtest" = inputs.homebrew-speedtest;
      };
    };

    # Generates a Brewfile from the lists below and runs `brew bundle` on activation.
    homebrew = {
      enable = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
      inherit (cfg) brews casks;

      onActivation = {
        # Remove anything not declared here, including cask leftovers.
        cleanup = "zap";
        # Keep `darwin-rebuild switch` idempotent; upgrade explicitly with `brew upgrade`.
        autoUpdate = false;
        upgrade = false;
        extraEnv = {
          HOMEBREW_NO_ANALYTICS = "1";
          HOMEBREW_NO_ENV_HINTS = "1";
        };
      };

      global.autoUpdate = false;
      enableZshIntegration = true;
    };
  };
}
