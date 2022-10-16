{ config, pkgs, ... }:

{
  imports = [
    ../modules/alacritty.nix
    ../modules/git.nix
    ../modules/nix-support.nix
    ../modules/nvim.nix
    ../modules/tmux.nix
    ../modules/wm.nix
    ../modules/zsh.nix
    #~/.config/nixpkgs/home-untracked.nix
  ];

  config = {
    targets.genericLinux.enable = true;
    programs.zsh.sessionVariables.NIX_PATH =
      "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";

    xsession.windowManager.i3.config.terminal =
      pkgs.lib.mkForce "~/.nix-profile/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty";
    xsession.windowManager.i3.x-barmode = "hide";
    xsession.windowManager.i3.x-trayOutput = "eDP1";

    # xsession.windowManager.i3.config = {
    #   keybindings = {
    #     XF86AudioMicMute = "exec pactl set-source-mute @DEFAULT_SOURCE@";
    #   };
    # };
    # xsession.windowManager.i3.config.keybindings."XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    # xsession.windowManager.i3.config.keybindings."XF86MonBrightnessUp" = "exec xbacklight +10";
    # xsession.windowManager.i3.config.keybindings."XF86MonBrightnessDown" = "exec xbacklight -10";
    # xsession.windowManager.i3.config.keybindings."XF86Display" = "exec arandr";

    systemd.user.systemctlPath = "/bin/systemctl";

    services.screen-locker.i3lockPath = "/usr/bin/i3lock";

    services.picom.package = let
      wrapper = pkgs.writeShellScriptBin "picom" ''
        ~/.nix-profile/bin/nixGLIntel ${pkgs.picom}/bin/picom $@
      '';
    in pkgs.symlinkJoin {
      name = "picom-nixGL";
      paths = [ wrapper pkgs.picom ];
    };

    services.network-manager-applet.enable = true;
    services.syncthing.tray.enable = true;

    xsession.windowManager.i3.config.startup = [{
      command =
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
      notification = false;
    }];

    home.packages = with pkgs; [
      cachix
      cntr
      niv
      zotero
    ];

    programs.alacritty.settings.font.size = 6;
    programs.bat.enable = true;

    programs.zsh.oh-my-zsh.plugins = ["gpg-agent"];

    programs.i3status.modules."battery all".enable = pkgs.lib.mkForce true;
    programs.i3status.modules."wireless _first_".enable = pkgs.lib.mkForce true;

    # programs.git.userEmail is untracked.

    programs.direnv.enable = true;
    services.lorri.enable = true;

    # Yubico U2F keys are untracked
    # home.file.".config/Yubico/u2f_keys" = {
    #   text = ''
    #   '';
    # };

    # programs.ssh.enable = true;
    # programs.ssh.matchBlocks is untracked

    home.keyboard.options = [ "compose:rctrl" ];

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
