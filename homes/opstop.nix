{ config, pkgs, ... }:

{
  imports = [
    ../modules/git.nix
    ../modules/zsh.nix
    ../modules/tmux.nix
    ../modules/alacritty.nix
    ../modules/wm.nix
    ../modules/wm/workspace-wrangler.nix
    ../modules/nvim.nix
    ~/.config/nixpkgs/home-untracked.nix
  ];

  config = {
    home.packages = with pkgs; [
      mpv-with-scripts
      pavucontrol
      signal-desktop
      spotify
      teams
      zotero

      recursive

      black
      cachix
      fd
      feh
      gron
      jq
      niv
      nix-output-monitor
      nix-tree
      overmind
      playerctl
      ripgrep
      tree
      xclip
    ];

    targets.genericLinux.enable = true;
    programs.zsh.sessionVariables.NIX_PATH =
      "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";

    nix.package = pkgs.nix;
    nix.settings = {
      experimental-features = ["flakes" "nix-command"];
    };
    programs.zsh.shellAliases = {
      nrc = "nix run -c ";
      nsh = ''nix run -c env IN_NIX_SHELL=1 NIX_SHELL_NAME="''${NIX_SHELL_NAME:-}-$(basename "$PWD")" $SHELL'' ;
      master = ''git checkout master && git pull && git prune-gone'';
    };

    home.keyboard.options = [ "compose:rctrl" ];

    # programs.git.userEmail is untracked.

    xsession.windowManager.i3.config.terminal =
      pkgs.lib.mkForce "~/.nix-profile/bin/nixGL alacritty";

    xsession.windowManager.i3.x-barmode = "hide";
    xsession.windowManager.i3.x-trayOutput = "eDP-1-1";
    xsession.windowManager.i3.x-primaryMonitors = [
      "DP-1-1" "DP-1-1-1" "DP-1-1-2" "DP-1-1-3"
      "DP-1-2" "DP-1-2-1" "DP-1-2-2" "DP-1-2-3"
      "DP-1-3" "DP-1-3-1" "DP-1-3-2" "DP-1-3-3"
    ];
    xsession.windowManager.i3.x-secondaryMonitor = "eDP-1-1";

    programs.i3status.modules."battery all".enable = pkgs.lib.mkForce true;
    programs.i3status.modules."wireless _first_".enable = pkgs.lib.mkForce true;

    programs.autorandr.enable = true;

    systemd.user.systemctlPath = "/bin/systemctl";

    services.screen-locker.i3lockPath = "/usr/bin/i3lock";

    services.picom.enable = pkgs.lib.mkForce false;

    services.network-manager-applet.enable = true;

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

    programs.direnv.enable = true;
    services.lorri.enable = true;

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
