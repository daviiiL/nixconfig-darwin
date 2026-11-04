{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.languages.dart;
in {
  options.localHome.programs.development.languages.dart.enable =
    lib.mkEnableOption "Dart SDK (pinned in overlays/)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dart
    ];
  };
}
