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
    ../modules/wm/workspace-wrangler.nix
    ../modules/zsh.nix
    # ~/.config/nixpkgs/home-untracked.nix
  ];

  config = {
    home.packages = with pkgs; [
      mpv
      pavucontrol
      signal-desktop
      spotify
      teams
      zotero

      recursive

      black
      fd
      feh
      gron
      jq
      overmind
      playerctl
      ripgrep
      tree
      xclip
    ];

    programs.zsh.shellAliases = {
      master = ''git checkout master && git pull && git prune-gone'';
    };

    home.keyboard.options = [ "compose:rctrl" ];

    # programs.git.userEmail is untracked.

    xsession.windowManager.i3.x-barmode = "hide";
    xsession.windowManager.i3.x-trayOutput = "eDP-1-1";
    xsession.windowManager.i3.x-primaryMonitors = [
      "DP-1-1" "DP-1-1-1" "DP-1-1-2" "DP-1-1-3"
      "DP-1-2" "DP-1-2-1" "DP-1-2-2" "DP-1-2-3"
      "DP-1-3" "DP-1-3-1" "DP-1-3-2" "DP-1-3-3"
    ];
    xsession.windowManager.i3.x-secondaryMonitor = "eDP-1-1";

    # Ubuntu 22.04 does not set SSH_AUTH_SOCK on login, so don't import-environment it
    xsession.importedVariables = pkgs.lib.mkForce [
      "DBUS_SESSION_BUS_ADDRESS"
      "DISPLAY"
      "XAUTHORITY"
      "XDG_DATA_DIRS"
      "XDG_RUNTIME_DIR"
      "XDG_SESSION_ID"
    ];

    programs.i3status.modules."battery all".enable = pkgs.lib.mkForce true;
    programs.i3status.modules."wireless _first_".enable = pkgs.lib.mkForce true;

    programs.autorandr.enable = true;

    services.picom.enable = pkgs.lib.mkForce false;

    services.network-manager-applet.enable = true;

    services.kdeconnect.enable = true;
    services.kdeconnect.indicator = true;

    xsession.windowManager.i3.config.startup = [
      {
        command =
          "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1";
        notification = false;
      }
      {
        command = "/bin/systemctl --user start i3-graphical-session.target";
        notification = false;
      }
      {
        command = "/usr/bin/ibus exit";
        notification = false;
      }
    ];

    systemd.user.targets = {
      i3-graphical-session = {
        Unit = {
          Description = "i3 graphical session";
          BindsTo = "graphical-session.target";
        };
      };
    };

    services.random-background = {
      enable = true;
      enableXinerama = true;
      imageDirectory = "%h/Pictures/Wallpapers";
      interval = "15m";
    };

    programs.neovim.plugins = [
      {
        plugin = pkgs.vimPlugins.vim-terraform;
        config = ''
          let g:terraform_align = 1
          let g:terraform_fold_sections = 1
          let g:hcp_align = 1
          let g:hcl_fold_sections = 1

          autocmd FileType terraform setlocal formatprg=terraform\ fmt\ -
        '';
      }
    ];

    home.sessionPath = [ "$HOME/.cargo/bin" ];

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
