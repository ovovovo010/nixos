{ config, pkgs, lib, ... }:

{
  # KWin 窗口管理器配置
  programs.plasma = {
    enable = true;
    
    # KWin 合成器設置
    workspace.windowDecorations.library = "org.kde.breeze";
    
    kwin = {
      # 基本合成器設置
      effects = {
        # 關閉可能影響遊戲性能的效果
        blur.enable = false;
        desktopSwitching.enable = false;
        dimInactive.enable = false;
        translucency.enable = false;
        wobblyWindows.enable = false;
        
        # 保持必要的效果
        windowAperture.enable = false;
      };
      
      # 遊戲優化設置
      virtualDesktops = {
        number = 2;
        rows = 1;
      };
    };
  };

  # KWin 腳本和規則（通過 dotfiles）
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
      
      # VSync 設置（遊戲時可能需要關閉）
      GLPreferBufferSwap = "a";
      UnredirectFullscreen = true;  # 全屏遊戲時關閉合成
    };
    
    Windows = {
      # 遊戲窗口優化
      FocusPolicy = "FocusFollowsMouse";
      FocusStealingPreventionLevel = 0;  # 允許遊戲搶焦點
      Placement = "Centered";
      
      # 邊框設置
      BorderlessMaximizedWindows = false;
    };
    
    Plugins = {
      # 禁用可能造成卡頓的插件
      blurEnabled = false;
      contrastEnabled = false;
      kwin4_effect_fadingpopupsEnabled = false;
      slideEnabled = false;
      
      # 保持基本功能
      kwin4_effect_translucencyEnabled = false;
      zoomEnabled = false;
    };
    
    Effect-PresentWindows = {
      # 禁用桌面網格效果
      Enabled = false;
    };
    
    TabBox = {
      # Alt+Tab 設置
      LayoutName = "thumbnail_grid";
      ShowTabBox = true;
    };
  };

  # 遊戲專用窗口規則
  home.file.".config/kwinrulesrc".text = lib.generators.toINI {} {
    # Steam 遊戲通用規則
    "steam-games" = {
      Description = "Steam Games";
      wmclass = "steam_app_";
      wmclassmatch = 2;  # substring match
      
      # 性能優化
      noborder = true;
      noborderrule = 2;
      fsplevel = 0;
      fsplevellevel = 2;
      
      # 防止合成器干擾
      blockcompositing = true;
      blockcompositingrule = 2;
    };
    
    # Wine/Proton 遊戲
    "wine-games" = {
      Description = "Wine Games";
      wmclass = "wine steam";
      wmclassmatch = 2;
      
      noborder = true;
      noborderrule = 2;
      blockcompositing = true;
      blockcompositingrule = 2;
    };
  };

  # 安裝遊戲相關工具
  home.packages = with pkgs; [
    # 性能監控
    mangohud
    goverlay
    
    # 遊戲啟動器
    steam-run
    gamescope  # 可選：Valve 的微合成器
  ];

  # Gamescope 環境變數（可選）
  home.sessionVariables = {
    # 強制使用 X11（某些遊戲在 Wayland 有問題）
    # QT_QPA_PLATFORM = "xcb";
    
    # MangoHud 預設關閉
    MANGOHUD = "0";
  };
}
