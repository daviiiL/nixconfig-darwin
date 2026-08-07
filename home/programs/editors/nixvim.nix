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
    home.packages = with pkgs; [
      ripgrep
      prettierd
      inputs.nixviii.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
