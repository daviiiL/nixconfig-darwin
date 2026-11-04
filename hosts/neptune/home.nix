{
  outputs,
  host,
  ...
}: {
  imports = [
    ../../home
  ];

  localHome = {
    platform.darwin.applications.enable = true;

    programs = {
      shell.zsh.enable = true;
      shell.starship.enable = true;
      cli.coreutils.enable = true;
      cli.networking.enable = true;
      cli.ripgrep.enable = true;
      development.direnv.enable = true;
      development.devenv.enable = true;
      development.git.enable = true;
      development.aws.enable = true;
      development.languages = {
        node.enable = true;
        dart.enable = true;
        php.enable = true;
        latex.enable = true;
        nix.enable = true;
      };
      development.databases = {
        mysql.enable = true;
        postgresql.enable = true;
      };
      editors.nixvim.enable = false;
      editors.tree-sitter.enable = true;
      terminals.tmux.enable = true;
      terminals.zellij.enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [outputs.overlays.default];
  };

  home = {
    username = host.user;
    homeDirectory = "/Users/${host.user}";
  };

  programs.home-manager.enable = true;
  home.stateVersion = import ../state-version.nix;
}
