{ config, pkgs, lib, ... }:

{
  config = {
    targets.genericLinux.enable = true;

    programs.zsh.sessionVariables.NIX_PATH =
      "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";

    services.screen-locker.i3lockPath = "/usr/bin/i3lock";

    systemd.user.systemctlPath = "/bin/systemctl";
  };
}
