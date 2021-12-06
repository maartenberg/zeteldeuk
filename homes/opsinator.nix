{ config, pkgs, ... }:

{
  imports = [
    ~/scratch/zeteldeuk/modules/git.nix
    ~/scratch/zeteldeuk/modules/zsh.nix
    ~/scratch/zeteldeuk/modules/tmux.nix
    ~/scratch/zeteldeuk/modules/alacritty.nix
    ~/scratch/zeteldeuk/modules/wm.nix
    ~/scratch/zeteldeuk/modules/nvim.nix
    ~/.config/nixpkgs/home-untracked.nix
  ];

  config = {
    home.packages = with pkgs; [
      recursive

      black
      cachix
      feh
      mpv-with-scripts
      niv
      nix-output-monitor
      nix-tree
      overmind
      playerctl
      ripgrep
      rofi
      vscode
    ];

    targets.genericLinux.enable = true;
    programs.zsh.sessionVariables.NIX_PATH =
      "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";

    programs.zsh.shellAliases = {
      nrc = "nix run -c ";
      nsh = "nix run -c $SHELL";
    };

    # programs.git.userEmail is untracked.

    xsession.windowManager.i3.config.terminal =
      pkgs.lib.mkForce "~/.nix-profile/bin/nixGL alacritty";

    programs.autorandr.enable = true;

    systemd.user.systemctlPath = "/bin/systemctl";

    services.screen-locker.i3lockPath = "/usr/bin/i3lock";

    services.picom.package = let
      wrapper = pkgs.writeShellScriptBin "picom" ''
        ~/.nix-profile/bin/nixGL ${pkgs.picom}/bin/picom $@
      '';
    in pkgs.symlinkJoin {
      name = "picom-nixGL";
      paths = [ wrapper pkgs.picom ];
    };

    xsession.windowManager.i3.config.startup = [{
      command =
        "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1";
      notification = false;
    }];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Generate HTML manual and make available as `home-manager-help`
    manual.html.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "maarten";
    home.homeDirectory = "/home/maarten";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.03";
  };
}
