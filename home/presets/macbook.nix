{
  localHome = {
    platform.darwin.applications.enable = true;

    programs = {
      shell.zsh.enable = true;
      shell.starship.enable = true;
      cli.coreutils.enable = true;
      development.direnv.enable = true;
      editors.nixvim.enable = true;
    };

    # Enable as leaf modules get ported from the linux config:
    # programs = {
    #   terminals.alacritty.enable = true;
    #   cli.fastfetch.enable = true;
    # };
  };
}
