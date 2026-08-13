{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.devenv;
in {
  options.localHome.programs.development.devenv.enable =
    lib.mkEnableOption "devenv (declarative per-project dev environments)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.devenv];
  };
}
