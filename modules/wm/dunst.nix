{ config, pkgs, lib, ... }:

{
  config = {
    services.dunst.enable = true;

    systemd.user.services.dunst.Service.Restart = "always";
    systemd.user.services.dunst.Service.RestartSec = "10s";

    services.dunst.settings = let bg = "#2d2d2d";
    in {
      global = {
        font = "Rec Mono Duotone 11";

        markup = "full";

        alignment = "center";

        show_age_threshold = -1;
        hide_duplicate_count = true;

        shrink = true;

        idle_threshold = 60;

        follow = "mouse";

        line_height = 3;

        background = bg;

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
