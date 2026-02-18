{ config, pkgs, ... }:

let
  flavor = "macchiato";
  accent = "lavender";
  cursorName = "catppuccin-macchiato-lavender-cursors";
  gtkThemeName = "Catppuccin-Macchiato-Standard-Lavender-Dark";

  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = [ accent ];
    size = "standard";
    tweaks = [ "normal" ];
    variant = flavor;
  };

  kvantumTheme = pkgs.catppuccin-kvantum.override {
    accent = "lavender";
    variant = "macchiato";
  };
in
{
  # ── 滑鼠主題 ────────────────────────────────────────────────────────
  home.pointerCursor = {
    name = cursorName;
    size = 24;
    package = pkgs.catppuccin-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  # ── GTK 主題 ────────────────────────────────────────────────────────
  gtk = {
    enable = true;

    theme = {
      name = gtkThemeName;
      package = gtkTheme;
    };

    cursorTheme = {
      name = cursorName;
      size = 24;
      package = pkgs.catppuccin-cursors;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # GTK4 需要手動 symlink
  xdg.configFile = {
    "gtk-4.0/gtk.css" = {
      source = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/gtk.css";
      force = true;
    };
    "gtk-4.0/gtk-dark.css" = {
      source = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/gtk-dark.css";
      force = true;
    };
    "gtk-4.0/assets" = {
      source = "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/assets";
      recursive = true;
      force = true;
    };

    # Kvantum 設定
    "Kvantum/catppuccin" = {
      source = "${kvantumTheme}/share/Kvantum/catppuccin-macchiato-lavender";
      recursive = true;
    };
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-macchiato-lavender
    '';
  };

  # ── Qt 主題（用 Kvantum）───────────────────────────────────────────
  home.packages = with pkgs; [
    kvantumTheme
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6Packages.qtstyleplugin-kvantum
    catppuccin-cursors
  ];

  # Qt 環境變數
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    XCURSOR_THEME = cursorName;
    XCURSOR_SIZE = "24";
  };

  # qt5ct 設定
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=
    custom_palette=false
    icon_theme=
    standard_dialogs=default
    style=kvantum

    [Fonts]
    fixed=@Variant(\0\0\0@\0\0\0\x12\0M\0o\0n\0o\0s\0p\0\x61\0\x63\0\x65@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    general=@Variant(\0\0\0@\0\0\0\n\0S\0\x61\0n\0s@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

    [Interface]
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3
  '';
}
