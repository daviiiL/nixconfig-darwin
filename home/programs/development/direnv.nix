{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.development.direnv;
in {
  options.localHome.programs.development.direnv.enable =
    lib.mkEnableOption "direnv with nix-direnv (cached, GC-rooted dev shells)";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
