{ config, pkgs, ... }:

{
  config = {
    programs.bat.enable = true;
    programs.bat.config = {
      theme = "gruvbox-dark";
    };

    programs.zsh = {
      enable = true;

      defaultKeymap = "viins";

      # Settings for OMZ's `timer` plugin.
      sessionVariables.TIMER_THRESHOLD = "5";
      sessionVariables.TIMER_FORMAT = "[%d]";

      sessionVariables.MANPAGER = "sh -c 'col -bx | bat -l man -p'";

      initExtra = ''
        # Run setup for zsh-nix-shell.
        prompt_nix_shell_setup
      '';

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

      plugins = [
        # Default to using `zsh` as the shell for `nix-shell`.
        {
          name = "nix-shell";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
        # Provide Nix completions.
        {
          name = "nix";
          src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
        }
      ];
    };
  };
}
# vim: ft=nix
