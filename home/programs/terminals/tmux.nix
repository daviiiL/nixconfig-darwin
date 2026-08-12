{
  config,
  lib,
  ...
}: let
  cfg = config.localHome.programs.terminals.tmux;
in {
  options.localHome.programs.terminals.tmux.enable =
    lib.mkEnableOption "tmux terminal multiplexer";

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 50000;
      mouse = true;
      escapeTime = 10;
      focusEvents = true;
      baseIndex = 1;
      keyMode = "vi";
      sensibleOnTop = false;

      extraConfig = ''
        set -ga terminal-overrides ",xterm-256color:RGB"
        set -g renumber-windows on

        # Reload config with prefix + r
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

        # Intuitive split keys, opening in the current pane's directory
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # Vim-style pane navigation with prefix + h/j/k/l
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Vi-style copy mode (prefix + [ to enter, v to select, y to yank)
        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send -X copy-selection-and-cancel

        # Status bar
        set -g status-position bottom
        set -g status-style "bg=colour235,fg=colour248"
        set -g status-left "#[bold] #S "
        set -g status-left-length 30
        set -g status-right " %Y-%m-%d %H:%M "
        setw -g window-status-current-style "bg=colour31,fg=colour255,bold"
        setw -g window-status-current-format " #I:#W "
        setw -g window-status-format " #I:#W "
      '';
    };
  };
}
