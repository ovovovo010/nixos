{ config, pkgs, ... }:

{
  home.pointerCursor = {
    name = "catppuccin-macchiato-lavender-cursors";
    size = 24;
    package = pkgs.catppuccin-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  # 讓 GTK 應用也套用
  gtk = {
    enable = true;
    cursorTheme = {
      name = "catppuccin-macchiato-lavender-cursors";
      size = 24;
      package = pkgs.catppuccin-cursors;
    };
  };
}
