{ config, pkgs, lib, ... }:

{
  options = {
    xsession.windowManager.i3.x-primaryMonitors =
      lib.mkOption { type = lib.types.listOf lib.types.str; };
    xsession.windowManager.i3.x-secondaryMonitor =
      lib.mkOption { type = lib.types.str; };
  };

  config = {
    xsession.windowManager.i3.config.workspaceOutputAssign = let
      primaryWorkspaces = map toString (lib.lists.range 1 10);
      secondaryWorkspaces = map toString (lib.lists.range 11 20);
      tertiaryWorkspaces = map toString (lib.lists.range 21 30);
      primaryOutputs = lib.strings.concatStringsSep " "
        config.xsession.windowManager.i3.x-primaryMonitors;
      tertiaryOutputs = lib.strings.concatStringsSep " " (lib.lists.reverseList
        config.xsession.windowManager.i3.x-primaryMonitors);

      assignPrimary = workspace: {
        inherit workspace;
        output = primaryOutputs;
      };
      assignSecondary = workspace: {
        inherit workspace;
        output = config.xsession.windowManager.i3.x-secondaryMonitor;
      };
      assignTertiary = workspace: {
        inherit workspace;
        output = tertiaryOutputs;
      };

    in (map assignPrimary primaryWorkspaces)
    ++ (map assignSecondary secondaryWorkspaces)
    ++ (map assignTertiary tertiaryWorkspaces);

    home.file.autoautorandr = {
      executable = true;
      target = ".local/bin/autoautorandr";
      text = ''
        #!/usr/bin/env python3

        import os
        import signal
        import subprocess
        from typing import Any

        SUSPENDED: bool = False


        def suspend_handler(_signal: Any, _stack: Any) -> None:
          global SUSPENDED
          SUSPENDED = not SUSPENDED

          if SUSPENDED:
            subprocess.run(["notify-send", "autoautorandr suspended."])
          else:
            subprocess.run(["autorandr", "-c", "--default", "horizontal"])
            subprocess.run(["notify-send", "autoautorandr resumed."])


        if __name__ == "__main__":
          signal.signal(signal.SIGUSR1, suspend_handler)

          msg = subprocess.Popen(
            ["i3-msg", "--monitor", "-t", "subscribe", '["output"]'],
            stdout=subprocess.PIPE,
            text=True,
          )

          try:
            assert msg.stdout is not None
            while True:
              try:
                line = msg.stdout.readline()
                if not SUSPENDED:
                  subprocess.run(["autorandr", "-c", "--default", "horizontal"])
              except EOFError:
                break

          finally:
            msg.kill()
            msg.communicate()
      '';
    };

    home.packages = [ pkgs.arandr ];

    xsession.windowManager.i3.config.startup = [{
      command = "autoautorandr";
      notification = false;
    }];
  };
}
