{ config, pkgs, lib, ... }:

{
  options = {
    xsession.windowManager.i3.x-primaryMonitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
    xsession.windowManager.i3.x-secondaryMonitor = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    xsession.windowManager.i3.config.workspaceOutputAssign = let
      primaryWorkspaces = map toString (lib.lists.range 1 10);
      secondaryWorkspaces = map toString (lib.lists.range 11 20);
      primaryOutputs = lib.strings.concatStringsSep " " config.xsession.windowManager.i3.x-primaryMonitors;

      assignPrimary = workspace: {
        inherit workspace;
        output = primaryOutputs;
      };
      assignSecondary = workspace: {
        inherit workspace;
        output = config.xsession.windowManager.i3.x-secondaryMonitor;
      };

    in (map assignPrimary primaryWorkspaces) ++ (map assignSecondary secondaryWorkspaces);

    home.file.autoautorandr = {
      executable = true;
      target = ".local/bin/autoautorandr";
      text = ''
        #!/usr/bin/env python3

        import os
        import subprocess

        if __name__ == '__main__':
          msg = subprocess.Popen(
            ["i3-msg", "--monitor", "-t", "subscribe", '["output"]'],
            stdout=subprocess.PIPE,
            text=True,
          )

          try:
            while True:
              try:
                line = msg.stdout.readline()
                subprocess.run(["autorandr", "-c", "--default", "horizontal"])
              except EOFError:
                break

          finally:
            msg.kill()
            msg.communicate()
      '';
    };

    xsession.windowManager.i3.config.startup = [
      {
        command = "autoautorandr";
        notification = false;
      }
    ];
  };
}
