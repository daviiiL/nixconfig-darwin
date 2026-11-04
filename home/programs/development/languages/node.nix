{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.languages.node;
in {
  options.localHome.programs.development.languages.node.enable =
    lib.mkEnableOption "Node.js runtime";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
    ];
  };
}
