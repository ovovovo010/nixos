{ config, pkgs, ... }:

let
  gtkThemeName = "Catppuccin-Macchiato-Standard-Lavender-Dark";

  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = [ "lavender" ];
    size = "standard";
    tweaks = [ "normal" ];
    variant = "macchiato";
  };

  kvantumTheme = pkgs.catppuccin-kvantum.override {
    accent = "lavender";
    variant = "macchiato";
  };
in
{
  # ── GTK 主題 ────────────────────────────────────────────────────────
  gtk = {
    enable = true;

    theme = {
      name = gtkThemeName;
      package = gtkTheme;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # GTK4 libadwaita fix
  xdg.configFile."gtk-4.0/gtk.css" = {
    source = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/gtk.css";
    force = true;
  };
  xdg.configFile."gtk-4.0/gtk-dark.css" = {
    source = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/gtk-dark.css";
    force = true;
  };
  xdg.configFile."gtk-4.0/assets" = {
    source = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/assets";
    recursive = true;
    force = true;
  };

  # ── Kvantum（Qt 主題）──────────────────────────────────────────────
  xdg.configFile = {
    "Kvantum/catppuccin" = {
      source = "${kvantumTheme}/share/Kvantum/catppuccin-macchiato-lavender";
      recursive = true;
    };
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-macchiato-lavender
    '';
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=kvantum
      color_scheme_path=
      custom_palette=false

      [Interface]
      menus_have_icons=true
      toolbutton_style=4
    '';
  };

  home.packages = with pkgs; [
    kvantumTheme
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6Packages.qtstyleplugin-kvantum
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
