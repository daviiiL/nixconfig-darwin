{
  config,
  lib,
  ...
}: {
  options.localSystem.hardware.darwin = {
    enable = lib.mkEnableOption "Darwin hardware tweaks (trackpad, startup chime)";
  };

  config = lib.mkIf config.localSystem.hardware.darwin.enable {
    system = {
      startup.chime = true;
      defaults.trackpad.TrackpadThreeFingerDrag = true;
    };
  };
}
