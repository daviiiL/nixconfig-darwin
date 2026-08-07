{
  config,
  lib,
  ...
}: let
  cfg = config.localSystem.core.settings;
in {
  options.localSystem.core.settings = {
    enable = lib.mkEnableOption "nix daemon settings (gc, optimisation, flakes)";
    gcRetention = lib.mkOption {
      type = lib.types.str;
      default = "5d";
      description = "Garbage collection retention period (e.g. \"5d\", \"30d\").";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      optimise.automatic = true;
      settings.experimental-features = ["nix-command" "flakes"];

      gc = {
        automatic = true;
        options = "--delete-older-than ${cfg.gcRetention}";
      };
    };
  };
}
