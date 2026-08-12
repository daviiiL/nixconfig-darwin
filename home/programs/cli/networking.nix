{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.cli.networking;
in {
  options.localHome.programs.cli.networking.enable =
    lib.mkEnableOption "networking utilities (ngrok, iperf3)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ngrok
      iperf3
    ];
  };
}
