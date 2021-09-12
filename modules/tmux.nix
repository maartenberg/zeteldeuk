{
  programs.tmux = {
    enable = true;

    # Vim keybindings
    keyMode = "vi";

    # Use modern TERM
    terminal = "tmux-256color";

    # Keep more history
    historyLimit = 8192;

    # Suggested by nvim: Wait shorter for escape codes.
    escapeTime = 10;

    extraConfig = ''
      # If a window is closed, renumber remaining windows to fill the gap.
      set -g renumber-windows on

      # Turn on window titles
      set -g set-titles on

      # Set window title string
      # #H: Hostname
      # #S: Session name
      # #W: Window name
      set -g set-titles-string 'maarten@#H: tmux #S:#W'

      # Automatically set window title
      setw -g automatic-rename on

      # :wq
      setw -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # Attempt to copy to the system clipboard if not remote.
      if-shell "test -z $SSH_CONNECTION" \
        "set -s set-clipboard on"
    '';
  };
}
