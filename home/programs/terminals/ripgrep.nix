{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.terminals.ripgrep;
in {
  options.localHome.programs.terminals.ripgrep.enable =
    lib.mkEnableOption "ripgrep (rg) fast recursive grep";

  config = lib.mkIf cfg.enable {
    programs.ripgrep.enable = true;
  };
}
