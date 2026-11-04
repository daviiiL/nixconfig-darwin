# Package pins and overrides, applied to home-manager's pkgs.
# Modules reference these by their normal names (pkgs.opencode, pkgs.dart).
{inputs}: final: prev: {
  # opencode 2.2.5 has a darwin node_modules hash mismatch; drop once fixed upstream
  # (along with the nixpkgs-opencode input).
  inherit (inputs.nixpkgs-opencode.legacyPackages.${final.stdenv.hostPlatform.system}) opencode;

  # nixpkgs lags the Dart stable channel; pin the latest release here.
  # Bump: check https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION
  # then `nix hash convert --hash-algo sha256 --to sri <sha256 from the .zip.sha256sum file>`.
  dart = prev.dart.overrideAttrs (finalAttrs: _prev: {
    version = "3.13.3";
    src = final.fetchurl {
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${finalAttrs.version}/sdk/dartsdk-macos-arm64-release.zip";
      hash = "sha256-xwO8uyXKDMXfkQn7gnLVJ4asFHgkN72eNloBmFJzwcw=";
    };
  });
}
