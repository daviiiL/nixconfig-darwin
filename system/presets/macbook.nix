{lib, ...}: {
  imports = [
    ../core/settings.nix
    ../hardware/darwin.nix
    ../security/darwin.nix
    ../packages/core.nix
  ];

  localSystem = {
    core.settings.enable = lib.mkDefault true;
    hardware.darwin.enable = lib.mkDefault true;
    security.darwin.enable = lib.mkDefault true;
    packages.core.enable = lib.mkDefault true;
  };
}
