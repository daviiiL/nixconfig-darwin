{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.languages.latex;
in {
  options.localHome.programs.development.languages.latex.enable =
    lib.mkEnableOption "LaTeX via tectonic";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tectonic
    ];
  };
}
