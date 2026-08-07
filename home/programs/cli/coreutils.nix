{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.cli.coreutils;
in {
  options.localHome.programs.cli.coreutils.enable =
    lib.mkEnableOption "everyday CLI bag (gh, eza, btop, fzf, zip, …)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gh

      eza
      btop
      fzf
      zip
      unzip
    ];
  };
}
