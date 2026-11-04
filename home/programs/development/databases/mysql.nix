{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.databases.mysql;
in {
  options.localHome.programs.development.databases.mysql.enable =
    lib.mkEnableOption "MySQL-compatible CLI client (via mariadb)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.mariadb.client];
  };
}
