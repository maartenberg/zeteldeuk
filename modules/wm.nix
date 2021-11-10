{ config, pkgs, lib, ... }:

{
  imports = [ ./wm/dunst.nix ./wm/i3.nix ./wm/screen-locker.nix ];

  config = {
    xsession.enable = true;
    xsession.numlock.enable = true;

    programs.rofi.enable = true;
    programs.rofi.theme = "gruvbox-dark";
    programs.rofi.font = "Rec Mono Duotone 14";

    services.pasystray.enable = true;

    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true;

      extraOptions = ''
        unredir-if-possible = true;
        vsync-use-glfinish = true;
        no-fading-openclose = true;
      '';
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
