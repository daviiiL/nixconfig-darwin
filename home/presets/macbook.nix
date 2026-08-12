{
  localHome = {
    platform.darwin.applications.enable = true;

    programs = {
      shell.zsh.enable = true;
      shell.starship.enable = true;
      cli.coreutils.enable = true;
      cli.networking.enable = true;
      development.direnv.enable = true;
      development.git.enable = true;
      development.aws.enable = true;
      development.languages.enable = true;
      development.databases.enable = true;
      editors.nixvim.enable = true;
      terminals.tmux.enable = true;
    };

    # Enable as leaf modules get ported from the linux config:
    # programs = {
    #   terminals.alacritty.enable = true;
    #   cli.fastfetch.enable = true;
    # };
  };
}
