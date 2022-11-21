{ config, pkgs, lib, ... }:

{
  options = {
    programs.nixGL.binary = lib.mkOption {
      type = lib.types.str;
      default = "nixGL";
    };
  };
  config = {
    targets.genericLinux.enable = true;

    programs.zsh.sessionVariables.NIX_PATH =
      "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";

    xsession.windowManager.i3.config.terminal =
      pkgs.lib.mkForce "${config.programs.nixGL.binary} alacritty";

    services.screen-locker.i3lockPath = "/usr/bin/i3lock";

    systemd.user.systemctlPath = "/bin/systemctl";

    services.picom.package = let
      wrapper = pkgs.writeShellScriptBin "picom" ''
        ${config.programs.nixGL.binary} ${pkgs.picom}/bin/picom $@
      '';
    in pkgs.symlinkJoin {
      name = "picom-nixGL";
      paths = [ wrapper pkgs.picom ];
    };
  };
}
