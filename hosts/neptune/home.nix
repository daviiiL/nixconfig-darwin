{
  imports = [
    ../../home
    ../../home/presets/macbook.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "davidliu";
    homeDirectory = "/Users/davidliu";
  };

  programs.home-manager.enable = true;
  home.stateVersion = import ../state-version.nix;
}
