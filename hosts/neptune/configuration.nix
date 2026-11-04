{
  self,
  host,
  ...
}: {
  imports = [
    ../../system
  ];

  localSystem = {
    core.settings.enable = true;
    hardware.darwin.enable = true;
    security.darwin.enable = true;
    packages.core.enable = true;
    packages.homebrew = {
      enable = true;
      brews = [
        "neovim"
        "teamookla/speedtest/speedtest"
      ];
    };
  };

  networking.hostName = host.name;

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = host.user;
  };

  nixpkgs.hostPlatform = host.system;
  system.stateVersion = 6;
}
