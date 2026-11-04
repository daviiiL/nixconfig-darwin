{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.editors.tree-sitter;
in {
  options.localHome.programs.editors.tree-sitter.enable =
    lib.mkEnableOption "tree-sitter CLI (used by editors to build parsers)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.tree-sitter];
  };
}
