{ config, pkgs, ... }:

{
  config = {
    programs.bat.enable = true;
    programs.bat.config = {
      theme = "gruvbox-dark";
    };

    programs.fzf = {
      enable = true;

      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
    };

    home.packages = with pkgs; [
      fd
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;

      syntaxHighlighting.enable = true;

      defaultKeymap = "viins";

      # Settings for OMZ's `timer` plugin.
      sessionVariables.TIMER_THRESHOLD = "5";
      sessionVariables.TIMER_FORMAT = "[%d]";

      oh-my-zsh = {
        enable = true;

        #theme = "wezm+";
        theme = "risto";

        plugins = [
          # Provide Git aliases.
          # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
          "git"
          # Enable substring search in history with arrow keys.
          # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history-substring-search
          "history-substring-search"
          # Auto-start SSH-agent.
          # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent
          "ssh-agent"
          # Print duration of long-running commands automatically.
          # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/timer
          "timer"
        ];
      };

      initExtra = ''
        function direnv_prompt_info() {
          if [[ -z ''${DIRENV_DIR} ]]; then
            return 0
          fi

          shell_name=$(basename -- "$DIRENV_DIR")
          echo "%F{8}[%F{3}''${shell_name}%F{8}]%f "
        }

        prompt="\$(direnv_prompt_info)''${prompt}"
      '';
    };
  };
}
# vim: ft=nix
