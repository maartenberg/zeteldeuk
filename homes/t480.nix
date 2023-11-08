{ config, pkgs, ... }:

{
  imports = [
    ../modules/alacritty.nix
    ../modules/git.nix
    ../modules/nix-support.nix
    ../modules/non-nixos.nix
    ../modules/nvim.nix
    ../modules/tmux.nix
    ../modules/wm.nix
    ../modules/zsh.nix
    #~/.config/nixpkgs/home-untracked.nix
  ];

  config = {
    xsession.windowManager.i3.x-barmode = "hide";
    xsession.windowManager.i3.x-trayOutput = "eDP1";

    services.network-manager-applet.enable = true;
    services.syncthing.tray.enable = true;

    xsession.windowManager.i3.config.startup = [{
      command =
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
      notification = false;
    }];

    programs.alacritty.settings.font.size = 6;
    programs.bat.enable = true;

    programs.zsh.oh-my-zsh.plugins = ["gpg-agent"];

    programs.i3status.modules."battery all".enable = pkgs.lib.mkForce true;
    programs.i3status.modules."wireless _first_".enable = pkgs.lib.mkForce true;

    # programs.git.userEmail is untracked.

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
