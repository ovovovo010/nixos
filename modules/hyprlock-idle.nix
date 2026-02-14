{ config, pkgs, lib, ... }:

{
  # Hyprlock - 鎖屏
  programs.hyprlock = {
    enable = true;
    
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
        no_fade_out = false;
      };

      background = [
        {
          path = "screenshot";  # 可改成 "~/Pictures/wallpaper/xxx.jpg"
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      # 時間顯示
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(255, 255, 255, 0.9)";
          font_size = 120;
          font_family = "JetBrains Mono Bold";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # 日期顯示
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgba(255, 255, 255, 0.7)";
          font_size = 24;
          font_family = "JetBrains Mono";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # 提示文字
        {
          monitor = "";
          text = "Enter Password to Unlock";
          color = "rgba(183, 148, 246, 0.8)";
          font_size = 18;
          font_family = "JetBrains Mono";
          position = "0, -150";
          halign = "center";
          valign = "center";
        }
        # 用戶名
        {
          monitor = "";
          text = "    $USER";
          color = "rgba(233, 213, 255, 0.9)";
          font_size = 20;
          font_family = "JetBrains Mono Bold";
          position = "0, -250";
          halign = "center";
          valign = "center";
        }
      ];

      # 輸入框
      input-field = [
        {
          monitor = "";
          size = "400, 60";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.35;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(124, 58, 237, 0.8)";
          inner_color = "rgba(26, 22, 37, 0.9)";
          font_color = "rgba(233, 213, 255, 1.0)";
          fade_on_empty = false;
          fade_timeout = 1000;
          placeholder_text = ''<span foreground="##a78bfa">Password...</span>'';
          hide_input = false;
          rounding = 12;
          check_color = "rgba(183, 148, 246, 0.8)";
          fail_color = "rgba(248, 113, 113, 0.8)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 2000;
          fail_transition = 300;
          capslock_color = "rgba(251, 191, 36, 0.8)";
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -300";
          halign = "center";
          valign = "center";
        }
      ];

      # 圓形頭像（可選）
      image = [
        {
          monitor = "";
          path = "~/.face";  # 可以放你的頭像圖片
          size = 150;
          rounding = -1;  # -1 = 圓形
          border_size = 4;
          border_color = "rgba(124, 58, 237, 0.8)";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle - 閒置管理
  services.hypridle = {
    enable = true;
    
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";  # 避免重複啟動
        before_sleep_cmd = "loginctl lock-session";  # 睡眠前鎖定
        after_sleep_cmd = "hyprctl dispatch dpms on";  # 喚醒後開啟螢幕
        ignore_dbus_inhibit = false;
      };

      listener = [
        # 5 分鐘後降低亮度
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        # 10 分鐘後鎖屏
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        # 15 分鐘後關閉螢幕
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # 30 分鐘後進入睡眠（可選）
        # {
        #   timeout = 1800;
        #   on-timeout = "systemctl suspend";
        # }
      ];
    };
  };

  # 確保必要的套件已安裝
  home.packages = with pkgs; [
    hyprlock
    hypridle
    brightnessctl  # 亮度控制
  ];

  # Hyprland 配置整合
  wayland.windowManager.hyprland = {
    settings = {
      # 開機自動啟動 hypridle
      exec-once = [
        "hypridle"
      ];
      
      # 綁定鎖屏快捷鍵
      bind = [
        "SUPER, L, exec, hyprlock"  # Super+L 鎖屏
      ];
    };
  };
}
