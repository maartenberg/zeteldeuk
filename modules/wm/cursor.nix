{
  config, pkgs, ...
}:

{
  config = {
    home.pointerCursor = {
      enable = true;
      name = "Wii-Pointer-P1";
      package = pkgs.callPackage ./primm-cursors.nix {};
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
