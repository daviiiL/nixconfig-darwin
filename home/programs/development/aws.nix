{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.aws;
in {
  options.localHome.programs.development.aws.enable =
    lib.mkEnableOption "AWS tooling (awscli2; cdk comes from npm)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
    ];
  };
}
