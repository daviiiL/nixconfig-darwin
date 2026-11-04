{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.localHome.programs.editors.nixvim;
in {
  options.localHome.programs.editors.nixvim.enable =
    lib.mkEnableOption "nixviii (custom Neovim) and dev dependencies";

  config = lib.mkIf cfg.enable {
    localHome.programs.cli.ripgrep.enable = true;

    home.packages = with pkgs; [
      prettierd
      # inputs.nixviii.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
