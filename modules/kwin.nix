# ~/.config/home-manager/kwin.nix
{ config, pkgs, lib, ... }:

{
  # 直接通過配置文件設置 KWin
  home.file.".config/kwinrc".text = lib.generators.toINI {} {
    Compositing = {
      Backend = "OpenGL";
      GLCore = true;
      GLPlatformInterface = "glx";
      LatencyPolicy = "ForceLowest";
      MaxFPS = 0;
      RefreshRate = 0;
      GLPreferBufferSwap = "a";
      UnredirectFullscreen = true;
      Enabled = true;
      HiddenPreviews = 5;
      OpenGLIsUnsafe = false;
    };
    
    "Compositing-X11" = {
      UnredirectFullscreen = true;
    };
    
    Windows = {
      FocusPolicy = "FocusFollowsMouse";
      FocusStealingPreventionLevel = 0;
      Placement = "Centered";
      BorderlessMaximizedWindows = false;
    };
    
    Plugins = {
      blurEnabled = false;
      contrastEnabled = false;
      kwin4_effect_fadingpopupsEnabled = false;
      slideEnabled = false;
      kwin4_effect_translucencyEnabled = false;
      zoomEnabled = false;
      desktopchangeosdEnabled = false;
      diminactiveEnabled = false;
      dimscreenEnabled = false;
      highlightwindowEnabled = true;
      kwin4_effect_squashEnabled = false;
      magiclampEnabled = false;
      windowgeometryEnabled = false;
      wobblywindowsEnabled = false;
    };
    
    Effect-PresentWindows = {
      Enabled = false;
    };
    
    Effect-DesktopGrid = {
      Enabled = false;
    };
    
    Effect-Cube = {
      Enabled = false;
    };
    
    TabBox = {
      LayoutName = "thumbnail_grid";
      ShowTabBox = true;
    };
    
    "org.kde.kdecoration2" = {
      ButtonsOnLeft = "M";
      ButtonsOnRight = "IAX";
      library = "org.kde.breeze";
      theme = "Breeze";
    };
  };

  # 窗口規則
  home.file.".config/kwinrulesrc".text = lib.generators.toINI {} {
    General = {
      count = 2;
      rules = "steam-games,wine-games";
    };
    
    steam-games = {
      Description = "Steam Games";
      wmclass = "steam_app_";
      wmclassmatch = 2;
      noborder = true;
      noborderrule = 2;
      fsplevel = 0;
      fsplevellrule = 2;
      blockcompositing = true;
      blockcompositingrule = 2;
      above = false;
      aboverule = 2;
      fullscreen = true;
      fullscreenrule = 3;
    };
    
    wine-games = {
      Description = "Wine Games";
      wmclass = "wine";
      wmclassmatch = 2;
      noborder = true;
      noborderrule = 2;
      blockcompositing = true;
      blockcompositingrule = 2;
      fullscreen = true;
      fullscreenrule = 3;
    };
  };

  # KDE 全局快捷鍵
  home.file.".config/kglobalshortcutsrc".text = lib.generators.toINI {} {
    kwin = {
      Expose = "none,Ctrl+F9,Toggle Present Windows (Current desktop)";
      ExposeAll = "none,,Toggle Present Windows (All desktops)";
      ExposeClass = "none,Ctrl+F7,Toggle Present Windows (Window class)";
    };
  };
}
