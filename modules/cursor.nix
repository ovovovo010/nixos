{ config, pkgs, ... }:

{
  home.pointerCursor = {
    name = "catppuccin-macchiato-lavender-cursors";
    size = 24;
    package = pkgs.catppuccin-cursors;
    gtk.enable = true;
    x11.enable = true;
  };
}
