{ config, pkgs, lib, ... }:

{
  # SwayNC - Sway Notification Center
  services.swaync = {
    enable = true;
    
    settings = {
      # 通知位置
      positionX = "right";
      positionY = "top";
      
      # 控制中心
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 0;
      
      control-center-width = 400;
      control-center-height = 600;
      
      # 通知設定
      notification-window-width = 400;
      notification-icon-size = 48;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      
      # 超時設定
      timeout = 5;
      timeout-low = 3;
      timeout-critical = 0;
      
      # 行為設定
      fit-to-screen = false;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      
      # 腳本行為
      script-fail-notify = true;
      
      # 小工具
      widgets = [
        "title"
        "dnd"
        "notifications"
      ];
      
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        
        dnd = {
          text = "Do Not Disturb";
        };
        
        notifications = {
          text = "Notifications";
        };
      };
    };
    
    style = ''
      * {
        font-family: JetBrains Mono, sans-serif;
        font-size: 14px;
        font-weight: 500;
      }

      /* ===== 通知窗口 ===== */
      .notification {
        background-color: rgba(26, 22, 37, 0.95);
        border: 2px solid #7c3aed;
        border-radius: 12px;
        margin: 8px;
        padding: 0;
      }

      .notification.critical {
        border-color: #f87171;
        background-color: rgba(40, 22, 37, 0.95);
      }

      /* 通知內容 */
      .notification-content {
        background-color: transparent;
        padding: 16px;
        margin: 0;
      }

      .notification-default-action {
        background-color: transparent;
        border-radius: 12px;
        margin: 0;
        padding: 0;
      }

      .notification-default-action:hover {
        background-color: rgba(124, 58, 237, 0.2);
      }

      /* 關閉按鈕 */
      .close-button {
        background-color: rgba(124, 58, 237, 0.5);
        color: #e9d5ff;
        border-radius: 8px;
        margin: 8px;
        padding: 4px 8px;
        border: none;
      }

      .close-button:hover {
        background-color: #7c3aed;
        color: #ffffff;
      }

      /* 通知標題 */
      .summary {
        color: #e9d5ff;
        font-weight: 700;
        font-size: 15px;
        margin-bottom: 4px;
      }

      /* 通知內容 */
      .body {
        color: #c4b5fd;
        font-size: 13px;
      }

      /* 通知時間 */
      .time {
        color: #a78bfa;
        font-size: 11px;
        margin-top: 4px;
      }

      /* 通知圖標 */
      .notification-icon {
        margin-right: 12px;
      }

      /* 圖片 */
      .body-image {
        border-radius: 8px;
        margin-top: 8px;
      }

      /* ===== 控制中心 ===== */
      .control-center {
        background-color: rgba(26, 22, 37, 0.95);
        border: 2px solid #7c3aed;
        border-radius: 16px;
        margin: 10px;
        padding: 0;
      }

      /* 控制中心標題 */
      .control-center .notification-row {
        background-color: transparent;
        border-radius: 12px;
        margin: 8px;
        padding: 0;
      }

      .control-center .notification-row:hover {
        background-color: rgba(124, 58, 237, 0.15);
      }

      /* 頂部標題列 */
      .widget-title {
        background-color: #2d1b4e;
        color: #e9d5ff;
        font-size: 18px;
        font-weight: 700;
        padding: 16px;
        margin: 12px 12px 8px 12px;
        border-radius: 12px;
      }

      .widget-title > button {
        background-color: #7c3aed;
        color: #ffffff;
        border: none;
        border-radius: 8px;
        padding: 8px 16px;
        font-weight: 600;
      }

      .widget-title > button:hover {
        background-color: #b794f6;
      }

      /* DND 開關 */
      .widget-dnd {
        background-color: #2d1b4e;
        color: #e9d5ff;
        padding: 12px 16px;
        margin: 8px 12px;
        border-radius: 12px;
        border: 2px solid transparent;
      }

      .widget-dnd:hover {
        border-color: #7c3aed;
      }

      .widget-dnd > switch {
        background-color: #4c2f7a;
        border-radius: 12px;
        border: none;
      }

      .widget-dnd > switch:checked {
        background-color: #7c3aed;
      }

      .widget-dnd > switch slider {
        background-color: #e9d5ff;
        border-radius: 10px;
      }

      /* 通知列表標籤 */
      .widget-label {
        color: #a78bfa;
        font-size: 16px;
        font-weight: 600;
        padding: 12px 16px;
        margin: 8px 12px 4px 12px;
      }

      /* 空通知狀態 */
      .blank-window {
        background-color: transparent;
        color: #a78bfa;
        font-size: 24px;
        padding: 40px;
      }

      /* Scrollbar */
      scrollbar {
        background-color: transparent;
        border-radius: 8px;
        width: 8px;
      }

      scrollbar trough {
        background-color: rgba(76, 47, 122, 0.3);
        border-radius: 8px;
      }

      scrollbar slider {
        background-color: #7c3aed;
        border-radius: 8px;
        min-height: 20px;
      }

      scrollbar slider:hover {
        background-color: #b794f6;
      }

      /* 按鈕通用樣式 */
      button {
        background-color: #2d1b4e;
        color: #e9d5ff;
        border: 2px solid transparent;
        border-radius: 8px;
        padding: 8px 12px;
        font-weight: 500;
      }

      button:hover {
        background-color: #3b2667;
        border-color: #7c3aed;
      }

      button:active {
        background-color: #7c3aed;
        color: #ffffff;
      }
    '';
  };

  # Hyprland 整合
  wayland.windowManager.hyprland = {
    settings = {
      # 開機啟動
      exec-once = [
        "swaync"
      ];
      
      # 快捷鍵綁定
      bind = [
        "SUPER, N, exec, swaync-client -t -sw"  # Super+N 開關通知中心
      ];
      
      # 窗口規則（讓通知浮動顯示）
      windowrulev2 = [
        "float, class:^(swaync)$"
        "noinitialfocus, class:^(swaync)$"
      ];
    };
  };

  # 確保套件已安裝
  home.packages = with pkgs; [
    swaynotificationcenter
    libnotify  # 提供 notify-send 命令
  ];
}
