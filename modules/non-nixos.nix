{ config, pkgs, ... }:

{
  config = {
    targets.genericLinux.enable = true;

    programs.zsh.sessionVariables.NIX_PATH =
      "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";

    xsession.windowManager.i3.config.terminal =
      pkgs.lib.mkForce "~/.nix-profile/bin/nixGLIntel alacritty";

    services.screen-locker.i3lockPath = "/usr/bin/i3lock";

    systemd.user.systemctlPath = "/bin/systemctl";

    services.picom.package = let
      wrapper = pkgs.writeShellScriptBin "picom" ''
        ~/.nix-profile/bin/nixGLIntel ${pkgs.picom}/bin/picom $@
      '';
    in pkgs.symlinkJoin {
      name = "picom-nixGL";
      paths = [ wrapper pkgs.picom ];
    };
  };
}
