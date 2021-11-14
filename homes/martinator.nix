{ config, pkgs, ... }:

{
  imports = [
    ~/code/zeteldeuk/modules/alacritty.nix
    ~/code/zeteldeuk/modules/git.nix
    ~/code/zeteldeuk/modules/wm.nix
    ~/code/zeteldeuk/modules/nvim.nix
    ~/code/zeteldeuk/modules/tmux.nix
    ~/code/zeteldeuk/modules/zsh.nix
    ~/.config/nixpkgs/home-untracked.nix
  ];

  config = {
    home.packages = with pkgs; [
      bitwarden
      cachix
      discord
      droidcam
      evince
      htop
      keepassxc
      niv
      obs-studio
      pavucontrol
      recursive
      virt-manager
      signal-desktop
      sl
      spotify
      tdesktop
      teams
      texlive.combined.scheme-full
      thunderbird

      jetbrains.clion

      libnotify
      wayland
      pcmanfm
      gnome3.file-roller
      mpv
      gimp
      feh
      ripgrep
      openssl
      pkg-config
      xclip
      jq
      curl
      wget
      tree
      unzip
      file
    ];

    # programs.git.userEmail is untracked.

    programs.firefox.enable = true;

    services.pulseeffects.enable = true;
    services.pulseeffects.package = pkgs.pulseeffects-legacy;

    services.syncthing.enable = true;
    services.syncthing.tray.enable = true;
    services.syncthing.tray.command = "syncthingtray --wait";

    services.kdeconnect.enable = true;
    services.kdeconnect.indicator = true;

    programs.autorandr.enable = true;
    # autorandr fingerprints are untracked.
    programs.autorandr.profiles.default.config = {
      "DisplayPort-0" = {
        enable = true;
        primary = true;
        mode = "1920x1200";
        position = "0x360";
        rate = "59.95";
      };

      "DisplayPort-1" = {
        enable = true;
        mode = "1920x1080";
        position = "1920x0";
        rate = "60.00";
        rotate = "left";
      };

      "DisplayPort-3".enable = false;
      "DisplayPort-4".enable = false;
      "HDMI-A-0".enable = false;
    };

    programs.autorandr.profiles.default.hooks.preswitch = ''
      xrandr --setmonitor 0 auto DisplayPort-0
      sleep 3
      xrandr --setmonitor 1 auto DisplayPort-1
      sleep 3
      i3-msg reload
    '';

    # Yubico U2F keys are untracked
    # home.file.".config/Yubico/u2f_keys" = {
    #   text = ''
    #   '';
    # };

    programs.ssh.enable = true;
    # programs.ssh.matchBlocks is untracked

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
