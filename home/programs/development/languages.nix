{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.localHome.programs.development.languages;

  # nixpkgs lags the Dart stable channel; pin the latest release here.
  # Bump: check https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION
  # then `nix hash convert --hash-algo sha256 --to sri <sha256 from the .zip.sha256sum file>`.
  dartLatest = pkgs.dart.overrideAttrs (final: _prev: {
    version = "3.13.3";
    src = pkgs.fetchurl {
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${final.version}/sdk/dartsdk-macos-arm64-release.zip";
      hash = "sha256-xwO8uyXKDMXfkQn7gnLVJ4asFHgkN72eNloBmFJzwcw=";
    };
  });
in {
  options.localHome.programs.development.languages.enable =
    lib.mkEnableOption "language runtimes and tooling (node, dart, tree-sitter)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      dartLatest
      tree-sitter
      tectonic
      phpactor
    ];
  };
}
