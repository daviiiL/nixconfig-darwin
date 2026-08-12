{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.databases;
in {
  options.localHome.programs.development.databases.enable =
    lib.mkEnableOption "database clients (mysql-compatible CLI via mariadb)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mariadb.client
    ];
  };
}
