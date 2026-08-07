{
  config,
  lib,
  ...
}: {
  options.localSystem.security.darwin = {
    enable = lib.mkEnableOption "Darwin hardening (SSH disabled, Touch ID for sudo)";
  };

  config = lib.mkIf config.localSystem.security.darwin.enable {
    services.openssh.enable = false;
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
