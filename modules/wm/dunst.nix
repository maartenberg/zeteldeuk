{ config, pkgs, lib, ... }:

{
  config = {
    services.dunst.enable = true;

    systemd.user.services.dunst.Service.Restart = "always";
    systemd.user.services.dunst.Service.StartLimitIntervalSec = "5s";

    services.dunst.settings = let bg = "#2d2d2d";
    in {
      global = {
        font = "Rec Mono Duotone 11";

        markup = true;
        plain_text = false;
        format = ''
          <b>%s</b>
          %b'';

        sort = false;
        indicate_hidden = true;

        alignment = "center";

        bounce_freq = 0;
        show_age_threshold = -1;
        word_wrap = true;
        ignore_newline = false;

        stack_duplicates = true;
        hide_duplicate_count = true;

        geometry = "300x50-15+49";
        shrink = true;

        transparency = 10;

        idle_threshold = 60;

        monitor = 0;
        follow = "none";

        sticky_history = true;
        show_indicators = true;

        line_height = 3;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;

        separator_color = "frame";
        frame_width = 3;

        background = bg;
      };

      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };

      urgency_low = {
        frame_color = bg;
        foreground = "#888888";
        background = bg;
        timeout = 4;
      };
      urgency_normal = {
        frame_color = "#5f676a";
        foreground = "#dedede";
        background = bg;
        timeout = 6;
      };
      urgency_critical = {
        frame_color = "#900000";
        foreground = "#dedede";
        background = bg;
        timeout = 8;
      };
    };
  };
}
