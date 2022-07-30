{ config, pkgs, lib, ... }:

{
  imports = [ ./wm/dunst.nix ./wm/i3.nix ./wm/screen-locker.nix ];

  config = {
    xsession.enable = true;
    xsession.numlock.enable = true;

    home.keyboard.options = [ "compose:rwin" ];

    programs.rofi.enable = true;
    programs.rofi.theme = "gruvbox-dark";
    programs.rofi.font = "Rec Mono Duotone 14";
    programs.rofi.extraConfig.run-command = "/usr/bin/env --unset=GDK_PIXBUF_MODULE_FILE {cmd}";

    services.pasystray.enable = true;

    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true;

      settings = {
        unredir-if-possible = true;
        vsync-use-glfinish = true;
        no-fading-openclose = true;
      };
    };

    # Ricing
    fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      theme = {
        package = pkgs.numix-gtk-theme;
        name = "Numix";
      };
      iconTheme = {
        package = pkgs.numix-icon-theme;
        name = "Numix";
      };
    };
  };
}
