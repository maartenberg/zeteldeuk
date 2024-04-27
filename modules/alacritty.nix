{ config, pkgs, ... }:

{
  config = {
    home.packages = [
      # Make "Rec Mono Duotone" font available
      pkgs.recursive
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        # Remote shells usually break when this is set to `alacritty`, so
        # pretend the terminal is `xterm`.
        env.TERM = "xterm-256color";

        # Disable borders and title bar (let WM handle it).
        window.decorations = "none";

        # Set "Rec Mono Duotone" as the font and override any other config to
        # make italic and bold styles use this font as well.
        font = { normal.family = "Rec Mono Duotone"; };

        # Scrollback
        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        # Use Numix Dark colors for the terminal.
        colors = {
          draw_bold_text_with_bright_colors = true;

          primary.background = "0x282828";
          primary.foreground = "0xeeeeee";

          selection.text = "0xffffff";
          selection.background = "0xf0544c";

          normal = {
            black = "0x555753";
            red = "0xef2929";
            green = "0x8ae234";
            yellow = "0xfce94f";
            blue = "0x729fcf";
            magenta = "0xad7fa8";
            cyan = "0x34e2e2";
            white = "0xeeeeec";
          };

          bright = {
            black = "0x555753";
            red = "0xef2929";
            green = "0x8ae234";
            yellow = "0xfce94f";
            blue = "0x729fcf";
            magenta = "0xad7fa8";
            cyan = "0x34e2e2";
            white = "0xeeeeec";
          };
        };

        # Misc.
        mouse.hide_when_typing = true;
        live_config_reload = true;
      };
    };
  };
}
