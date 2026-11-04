{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.languages.nix;
in {
  options.localHome.programs.development.languages.nix.enable =
    lib.mkEnableOption "Nix language servers (nil, nixd) and formatter (alejandra)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      nixd
      alejandra
    ];
  };
}
