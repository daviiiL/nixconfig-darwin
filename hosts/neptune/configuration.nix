{self, ...}: {
  imports = [
    ../../system/presets/macbook.nix
  ];

  networking.hostName = "neptune";

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = "davidliu";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
