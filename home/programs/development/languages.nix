{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.languages;
in {
  options.localHome.programs.development.languages.enable =
    lib.mkEnableOption "language runtimes and tooling (node, dart, tree-sitter)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      dart
      tree-sitter
    ];
  };
}
