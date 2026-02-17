{ config, pkgs, ... }:

{
  # ── Niri Wayland 合成器配置 ──────────────────────────────────────────
  # Niri 使用 TOML 格式的配置文件
  xdg.configFile."niri/config.toml".text = ''
    # Niri 配置檔案
    # 參考：https://github.com/YaLTeR/niri

    # ── 輸入配置 ─────────────────────────────────────────────────────
    [input]
    # 鍵盤配置
    [input.keyboard]
    xkb.layout = "us"
    xkb.options = ""
    xkb.rules = "evdev"
    repeat-delay = 600
    repeat-rate = 25

    # 滑鼠配置
    [input.pointer]
    accel-speed = 0.2
    accel-profile = "flat"

    # 觸控板配置
    [input.touchpad]
    tap = true
    natural-scroll = true
    click-method = "clickfinger"

    # ── 輸出配置 ─────────────────────────────────────────────────────
    # 輸出會自動偵測，這裡可以手動設定
    # [output."<output-name>"]
    # scale = 1.0
    # position = { x = 0, y = 0 }
    # mode = { width = 1920, height = 1080, refresh = 60.0 }
    # transform = "Normal"

    # ── 佈局配置 ─────────────────────────────────────────────────────
    [layout]
    gaps = 16
    struts = { left = 0, right = 0, top = 0, bottom = 0 }
    default-column-width = { fixed = 600 }
    center-focused-column = true
    center-focused-column-width = { fixed = 1200 }

    # ── 視窗規則 ─────────────────────────────────────────────────────
    # [window-rule]
    # match = "class:^(pavucontrol)$"
    # spawn-on-output = "DP-1"
    # open-on-output = "DP-1"

    # ── 動畫配置 ─────────────────────────────────────────────────────
    [animations]
    enabled = true
    slowdown = 1.0

    # ── 快捷鍵綁定 ───────────────────────────────────────────────────
    # 基本操作
    bind = [
      # 關閉視窗
      { key = "Q", mods = ["Mod"], action = "CloseWindow" },
      
      # 終端機
      { key = "Return", mods = ["Mod"], action = "Spawn", command = "kitty" },
      
      # 應用程式選單
      { key = "D", mods = ["Mod"], action = "Spawn", command = "rofi -show drun" },
      
      # 檔案管理器
      { key = "E", mods = ["Mod"], action = "Spawn", command = "thunar" },
      
      # 全螢幕
      { key = "F", mods = ["Mod"], action = "ToggleFullscreen" },
      
      # 切換浮動
      { key = "V", mods = ["Mod"], action = "ToggleFloating" },
      
      # 重新載入配置
      { key = "R", mods = ["Mod", "Shift"], action = "ReloadConfig" },
      
      # 退出 Niri
      { key = "Q", mods = ["Mod", "Shift"], action = "Quit" },
      
      # 工作區切換
      { key = "1", mods = ["Mod"], action = "FocusWorkspace", target = "1" },
      { key = "2", mods = ["Mod"], action = "FocusWorkspace", target = "2" },
      { key = "3", mods = ["Mod"], action = "FocusWorkspace", target = "3" },
      { key = "4", mods = ["Mod"], action = "FocusWorkspace", target = "4" },
      { key = "5", mods = ["Mod"], action = "FocusWorkspace", target = "5" },
      { key = "6", mods = ["Mod"], action = "FocusWorkspace", target = "6" },
      { key = "7", mods = ["Mod"], action = "FocusWorkspace", target = "7" },
      { key = "8", mods = ["Mod"], action = "FocusWorkspace", target = "8" },
      { key = "9", mods = ["Mod"], action = "FocusWorkspace", target = "9" },
      { key = "0", mods = ["Mod"], action = "FocusWorkspace", target = "10" },
      
      # 移動視窗到工作區
      { key = "1", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "1" },
      { key = "2", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "2" },
      { key = "3", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "3" },
      { key = "4", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "4" },
      { key = "5", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "5" },
      { key = "6", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "6" },
      { key = "7", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "7" },
      { key = "8", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "8" },
      { key = "9", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "9" },
      { key = "0", mods = ["Mod", "Shift"], action = "MoveWindowToWorkspace", target = "10" },
      
      # 視窗焦點切換（Vim 風格）
      { key = "H", mods = ["Mod"], action = "FocusColumnLeft" },
      { key = "L", mods = ["Mod"], action = "FocusColumnRight" },
      { key = "K", mods = ["Mod"], action = "FocusWindowUp" },
      { key = "J", mods = ["Mod"], action = "FocusWindowDown" },
      
      # 移動視窗
      { key = "H", mods = ["Mod", "Shift"], action = "MoveColumnLeft" },
      { key = "L", mods = ["Mod", "Shift"], action = "MoveColumnRight" },
      { key = "K", mods = ["Mod", "Shift"], action = "MoveWindowUp" },
      { key = "J", mods = ["Mod", "Shift"], action = "MoveWindowDown" },
      
      # 調整列寬
      { key = "Left", mods = ["Mod", "Control"], action = "ResizeColumn", target = "Left", pixels = 50 },
      { key = "Right", mods = ["Mod", "Control"], action = "ResizeColumn", target = "Right", pixels = 50 },
      
      # 媒體鍵
      { key = "XF86AudioRaiseVolume", action = "Spawn", command = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" },
      { key = "XF86AudioLowerVolume", action = "Spawn", command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" },
      { key = "XF86AudioMute", action = "Spawn", command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
      { key = "XF86MonBrightnessUp", action = "Spawn", command = "brightnessctl -e4 -n2 set 5%+" },
      { key = "XF86MonBrightnessDown", action = "Spawn", command = "brightnessctl -e4 -n2 set 5%-" },
    ]

    # ── 環境變數 ─────────────────────────────────────────────────────
    [environment]
    # 設定環境變數
    # NIRI_LOG = "debug"  # 除錯用，可移除
    XCURSOR_SIZE = "24"
  '';

  # ── 自動啟動腳本 ──────────────────────────────────────────────────
  xdg.configFile."niri/startup".text = ''
    #!/usr/bin/env bash
    # Niri 自動啟動腳本
    
    # 確保環境變數傳遞
    dbus-update-activation-environment --systemd --all
    
    # 啟動輸入法
    fcitx5 -d &
    
    # 啟動壁紙管理器（如果使用 swww）
    swww-daemon --format xrgb &
    swww img /home/eric/Pictures/wallpapers/tokyo_night_city_skyscrapers_121628_3840x2160.jpg --transition-type fade --transition-duration 2 &
    
    # 啟動 Waybar（如果需要）
    # waybar &
  '';

  # 設定啟動腳本為可執行
  xdg.configFile."niri/startup".executable = true;

  # ── 安裝必要套件 ──────────────────────────────────────────────────
  home.packages = with pkgs; [
    niri                    # Niri Wayland 合成器
    kitty                   # 終端機
    rofi                    # 應用程式啟動器
    brightnessctl           # 亮度控制
    wl-clipboard            # Wayland 剪貼簿
    playerctl               # 媒體控制
    # waybar                # 狀態列（可選，已在其他模組中配置）
    # swww                  # 壁紙管理器（可選，已在其他模組中配置）
  ];

  # ── 環境變數設定 ───────────────────────────────────────────────────
  home.sessionVariables = {
    # Wayland 相關
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    
    # NVIDIA 相關（如果使用 NVIDIA 顯卡）
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
