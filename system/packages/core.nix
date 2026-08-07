{
  config,
  lib,
  pkgs,
  ...
}: {
  options.localSystem.packages.core = {
    enable = lib.mkEnableOption "core system packages";
  };

  config = lib.mkIf config.localSystem.packages.core.enable {
    environment.systemPackages = with pkgs; [
      vim
      home-manager
    ];
  };
}
