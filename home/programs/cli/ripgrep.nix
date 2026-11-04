{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.cli.ripgrep;
in {
  options.localHome.programs.cli.ripgrep.enable =
    lib.mkEnableOption "ripgrep (rg) fast recursive grep";

  config = lib.mkIf cfg.enable {
    programs.ripgrep.enable = true;
  };
}
