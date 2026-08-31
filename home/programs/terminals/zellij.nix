{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.terminals.zellij;
in {
  options.localHome.programs.terminals.zellij.enable =
    lib.mkEnableOption "zellij terminal multiplexer";

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
  };
}
