{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.databases.postgresql;
in {
  options.localHome.programs.development.databases.postgresql.enable =
    lib.mkEnableOption "PostgreSQL client tools (psql, pg_dump, …)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.postgresql];
  };
}
