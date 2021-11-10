{ config, pkgs, lib, ... }:

{
  config = {
    xsession.windowManager.i3 = {
      enable = true;
      config = rec {
        menu = "rofi -show drun";
        terminal = "alacritty";
        modifier = "Mod4";

        startup = [{
          command = "autorandr -c";
          notification = false;
        }];

        colors.focused.border = "#444444";
        colors.focused.background = "#444444";
        colors.focused.text = "#dedede";
        colors.focused.indicator = "#d64937";
        colors.focused.childBorder = colors.focused.border;

        colors.unfocused.border = "#222222";
        colors.unfocused.background = "#222222";
        colors.unfocused.text = "#dedede";
        colors.unfocused.indicator = "#d64937";
        colors.unfocused.childBorder = colors.unfocused.border;

        colors.focusedInactive.border = "#333333";
        colors.focusedInactive.background = "#333333";
        colors.focusedInactive.text = "#dedede";
        colors.focusedInactive.indicator = "#d64937";
        colors.focusedInactive.childBorder = colors.focusedInactive.border;

        colors.urgent.border = "#383a3b";
        colors.urgent.background = "#383a3b";
        colors.urgent.text = "#ee0000";
        colors.urgent.indicator = "#383a3b";
        colors.urgent.childBorder = colors.urgent.border;

        assigns = {
          "number 9" = [{ class = "^Steam$"; }];

          "number 7" = [{ class = "TelegramDesktop"; }];

          "number 10" = [{ class = "discord"; }];
        };

        window.commands = [
          {
            criteria = { class = "Firefox"; };
            command = "layout tabbed, border none";
          }
          {
            criteria = { class = "discord"; };
            command = "border none";
          }
        ];

        keybindings = let
          mod = config.xsession.windowManager.i3.config.modifier;
          secondaries = lib.lists.range 11 20;
          switchToSecondaries = map (num: {
            name = "${mod}+Mod1+${toString (lib.trivial.mod num 10)}";
            value = "workspace number ${toString num}";
          }) secondaries;
          moveToSecondaries = map (num: {
            name = "${mod}+Mod1+Shift+${toString (lib.trivial.mod num 10)}";
            value = "move container to workspace number ${toString num}";
          }) secondaries;

        in lib.mkOptionDefault ({
          "${mod}+b" = "border toggle";
          "${mod}+Escape" = ''mode "RAW"'';
          "${mod}+Pause" = ''mode "System"'';
          "${mod}+Print" = ''mode "PrintScreen"'';
          "${mod}+Shift+f" = "fullscreen toggle global";

          "${mod}+Shift+F1" = "exec firefox";

          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioRaiseVolume" =
            "exec pactl set-sink-volume @DEFAULT_SINK@ +2%";
          "XF86AudioLowerVolume" =
            "exec pactl set-sink-volume @DEFAULT_SINK@ -2%";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        } // builtins.listToAttrs (switchToSecondaries ++ moveToSecondaries));

        modes = let mod = config.xsession.windowManager.i3.config.modifier;

        in lib.mkOptionDefault ({
          "RAW" = { "${mod}+Pause" = ''mode "default"''; };
          "System" = {
            "Escape" = ''mode "default"'';
            "Return" = ''mode "default"'';
            "l" = ''
              exec ${pkgs.systemd}/bin/loginctl lock-session; mode "default"'';
            "e" = "exit";
            "h" =
              ''exec ${pkgs.systemd}/bin/systemctl hibernate; mode "default"'';
            "s" =
              ''exec ${pkgs.systemd}/bin/systemctl suspend; mode "default"'';
            "Shift+s" =
              ''exec ${pkgs.systemd}/bin/systemctl poweroff; mode "default"'';
            "Shift+r" =
              ''exec ${pkgs.systemd}/bin/systemctl reboot; mode "default"'';
          };
          "PrintScreen" = let
            maimCommand = args: ''
              exec "${pkgs.maim}/bin/maim --hidecursor ${args} | tee ~/Pictures/Screenshots/$(date -Iseconds).png | xclip -sel clipboard -t image/png"
            '';
          in {
            "Escape" = ''mode "default"'';
            "Return" = ''mode "default"'';

            "s" = maimCommand "--select";
            "a" = maimCommand "--window=root";
          };
        });

        bars = [{
          colors.background = "#2d2d2d";
          colors.statusline = "#dedede";
          colors.separator = "#888888";

          colors.focusedWorkspace.border = "#d64937";
          colors.focusedWorkspace.background = "#d64937";
          colors.focusedWorkspace.text = "#dedede";

          colors.activeWorkspace.border = "#2d2d2d";
          colors.activeWorkspace.background = "#5f676a";
          colors.activeWorkspace.text = "#dedede";

          colors.inactiveWorkspace.border = "#2d2d2d";
          colors.inactiveWorkspace.background = "#2d2d2d";
          colors.inactiveWorkspace.text = "#888888";

          colors.urgentWorkspace.border = "#333333";
          colors.urgentWorkspace.background = "#900000";
          colors.urgentWorkspace.text = "#ffffff";

          colors.bindingMode = null;

          command = "i3bar";
          statusCommand = "i3status";
          extraConfig = "";

          mode = "dock";
          position = "bottom";
          hiddenState = null;

          trayOutput = "primary";
          workspaceButtons = true;
          workspaceNumbers = true;

          fonts = {
            names = [ "Rec Mono Duotone" ];
            style = "Regular";
            size = 9.0;
          };
        }];
      };

      extraConfig = let
        assign = monitor: space: ''
          workspace ${toString space} output ${monitor}
        '';

        primaryMonitor = "0";
        primaryWorkspaces = lib.lists.range 1 10;
        primaryAssigns = lib.strings.concatMapStrings (assign primaryMonitor)
          primaryWorkspaces;

        secondaryMonitor = "1";
        secondaryWorkspaces = lib.lists.range 11 20;
        secondaryAssigns =
          lib.strings.concatMapStrings (assign secondaryMonitor)
          secondaryWorkspaces;

      in ''
        ${primaryAssigns}
        ${secondaryAssigns}
      '';
    };

    programs.i3status.enable = true;

    programs.i3status.general.interval = 1;
    programs.i3status.modules."wireless _first_".enable = false;
    programs.i3status.modules."battery all".enable = false;
    programs.i3status.modules."memory".settings.format =
      "RAM: %percentage_used";

    programs.i3status.modules."volume master" = {
      enable = true;
      position = 7;
      settings = {
        format = "♪: %volume";
        format_muted = "♪: M (%volume)";
        device = "pulse";
      };
    };
  };
}
