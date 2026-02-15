# ~/.config/home-manager/kwin.nix
{ config, pkgs, lib, ... }:

{
  # 直接通過配置文件設置 KWin
  home.file.".config/kwinrc".text = lib.generators.toINI {} {
    Compositing = {
      # 渲染後端
      Backend = "OpenGL";
      GLCore = true;
      GLPlatformInterface = "glx";
      
      # 性能設置
      LatencyPolicy = "ForceLowest";
      MaxFPS = 0;  # 無限制
      RefreshRate = 0;  # 跟隨顯示器
      
      # VSync 設置
      GLPreferBufferSwap = "a";
      UnredirectFullscreen = true;  # 全屏遊戲時關閉合成
      
      # 啟用合成器
      Enabled = true;
      HiddenPreviews = 5;
      OpenGLIsUnsafe = false;
    };
    
    Compositing-X11 = {
      UnredirectFullscreen = true;
    };
    
    Windows = {
      # 遊戲窗口優化
      FocusPolicy = "FocusFollowsMouse";
      FocusStealingPreventionLevel = 0;  # 允許遊戲搶焦點
      Placement = "Centered";
      BorderlessMaximizedWindows = false;
    };
    
    Plugins = {
      # 禁用影響性能的效果
      blurEnabled = false;
      contrastEnabled = false;
      kwin4_effect_fadingpopupsEnabled = false;
      slideEnabled = false;
      kwin4_effect_translucencyEnabled = false;
      zoomEnabled = false;
      
      # 禁用桌面效果
      desktopchangeosdEnabled = false;
      diminactiveEnabled = false;
      dimscreenEnabled = false;
      highlightwindowEnabled = true;  # 保留窗口高亮
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
    
    org.kde.kdecoration2 = {
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
    
    # Steam 遊戲
    steam-games = {
      Description = "Steam Games";
      wmclass = "steam_app_";
      wmclassmatch = 2;  # substring match
      
      # 規則
      noborder = true;
      noborderrule = 2;
      fsplevel = 0;
      fsplevellrule = 2;
      blockcompositing = true;
      blockcompositingrule = 2;
      
      # 防止焦點被搶
      above = false;
      aboverule = 2;
      fullscreen = true;
      fullscreenrule = 3;  # Force
    };
    
    # Wine/Proton 遊戲
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

  # KDE 全局快捷鍵（可選）
  home.file.".config/kglobalshortcutsrc".text = lib.generators.toINI {} {
    kwin = {
      "Expose" = "none,Ctrl+F9,Toggle Present Windows (Current desktop)";
      "ExposeAll" = "none,,Toggle Present Windows (All desktops)";
      "ExposeClass" = "none,Ctrl+F7,Toggle Present Windows (Window class)";
    };
  };

  # 遊戲工具
  home.packages = with pkgs; [
    # 性能監控
    goverlay
    
    # 啟動工具
    steam-run
    gamescope
    
    # 系統監控
    htop
    iotop
  ];


  };
}
