{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;
        
        modules-left = [
          "custom/cat"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        
        modules-center = [
          "custom/music"
        ];
        
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
          "tray"
        ];

        # 🐱 8bit 小貓常駐！
        "custom/cat" = {
          format = "  ₍^ >ヮ<^₎ .ᐟ.ᐟ";
          tooltip = false;
          on-click = "notify-send '🐱 Nya~' 'Meow meow! (=^･ω･^=)'";
        };

        # 🎵 音樂播放器
        "custom/music" = {
          format = "{}";
          max-length = 60;
          interval = 1;
          exec = "~/.config/waybar/scripts/music.sh";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
          return-type = "json";
          escape = true;
        };

        # Hyprland 工作區
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # 當前窗口標題
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        # 音量
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "  Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        # 網路
        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "  Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        # CPU
        "cpu" = {
          format = "  {usage}%";
          tooltip = true;
          interval = 2;
        };

        # 記憶體
        "memory" = {
          format = "  {}%";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
          interval = 2;
        };

        # 電池
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{timeTo}";
        };

        # 時鐘
        "clock" = {
          format = "  {:%H:%M}";
          format-alt = "  {:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#b794f6'><b>{}</b></span>";
              days = "<span color='#e9d5ff'>{}</span>";
              weeks = "<span color='#a78bfa'>W{}</span>";
              weekdays = "<span color='#c4b5fd'><b>{}</b></span>";
              today = "<span color='#7c3aed'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        # 系統托盤
        "tray" = {
          icon-size = 18;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrains Mono", "Noto Color Emoji", sans-serif;
        font-size: 13px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 22, 37, 0.9);
        border-bottom: 3px solid #7c3aed;
        color: #e9d5ff;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      /* 可愛的小貓模組 */
      #custom-cat {
        background: linear-gradient(90deg, #fbbf24 0%, #f59e0b 100%);
        color: #ffffff;
        padding: 0 20px;
        margin: 4px 0px 4px 8px;
        border-radius: 20px;
        font-size: 14px;
        transition: all 0.3s ease;
      }

      #custom-cat:hover {
        background: linear-gradient(90deg, #fcd34d 0%, #fbbf24 100%);
        padding: 0 24px;
      }

      /* 超可愛的音樂播放器 */
      #custom-music {
        background: linear-gradient(90deg, #ec4899 0%, #f472b6 100%);
        color: #ffffff;
        padding: 0 20px;
        margin: 4px 8px;
        border-radius: 20px;
        font-size: 13px;
        transition: all 0.3s ease;
      }

      #custom-music:hover {
        background: linear-gradient(90deg, #f472b6 0%, #ec4899 100%);
        padding: 0 24px;
      }

      /* 工作區 */
      #workspaces {
        background-color: transparent;
        margin: 4px 4px;
      }

      #workspaces button {
        background-color: rgba(124, 58, 237, 0.3);
        color: #c4b5fd;
        padding: 0 12px;
        margin: 0 2px;
        border-radius: 12px;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background-color: rgba(124, 58, 237, 0.5);
        color: #e9d5ff;
      }

      #workspaces button.active {
        background: linear-gradient(90deg, #7c3aed 0%, #b794f6 100%);
        color: #ffffff;
      }

      #workspaces button.urgent {
        background-color: #f87171;
        color: #ffffff;
      }

      /* 窗口標題 */
      #window {
        background-color: transparent;
        color: #a78bfa;
        padding: 0 16px;
        font-weight: 500;
      }

      /* 右側模組通用樣式 */
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #battery,
      #clock,
      #tray {
        background-color: rgba(45, 27, 78, 0.8);
        color: #e9d5ff;
        padding: 0 16px;
        margin: 4px 2px;
        border-radius: 12px;
        transition: all 0.3s ease;
      }

      #pulseaudio:hover,
      #network:hover,
      #cpu:hover,
      #memory:hover,
      #battery:hover,
      #clock:hover {
        background-color: rgba(124, 58, 237, 0.6);
        border-bottom: 2px solid #b794f6;
      }

      /* 音量特殊顏色 */
      #pulseaudio {
        background: linear-gradient(90deg, #8b5cf6 0%, #a78bfa 100%);
      }

      #pulseaudio.muted {
        background-color: rgba(248, 113, 113, 0.6);
        color: #ffffff;
      }

      /* 網路狀態 */
      #network.disconnected {
        background-color: rgba(248, 113, 113, 0.6);
        color: #ffffff;
      }

      /* CPU 警告 */
      #cpu.warning {
        background-color: rgba(251, 191, 36, 0.8);
        color: #ffffff;
      }

      #cpu.critical {
        background-color: rgba(248, 113, 113, 0.8);
        color: #ffffff;
      }

      /* 記憶體警告 */
      #memory.warning {
        background-color: rgba(251, 191, 36, 0.8);
        color: #ffffff;
      }

      #memory.critical {
        background-color: rgba(248, 113, 113, 0.8);
        color: #ffffff;
      }

      /* 電池狀態 */
      #battery.charging {
        background: linear-gradient(90deg, #34d399 0%, #10b981 100%);
        color: #ffffff;
      }

      #battery.warning {
        background-color: rgba(251, 191, 36, 0.8);
        color: #ffffff;
      }

      #battery.critical {
        background-color: rgba(248, 113, 113, 0.8);
        color: #ffffff;
      }

      /* 時鐘特殊樣式 */
      #clock {
        background: linear-gradient(90deg, #7c3aed 0%, #b794f6 100%);
        color: #ffffff;
        font-weight: 700;
        margin-right: 8px;
      }

      /* 托盤 */
      #tray {
        background-color: rgba(45, 27, 78, 0.8);
        margin-right: 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f87171;
      }

      /* 滑鼠滑過整體效果 */
      tooltip {
        background-color: rgba(26, 22, 37, 0.95);
        border: 2px solid #7c3aed;
        border-radius: 12px;
        color: #e9d5ff;
        padding: 8px;
      }

      tooltip label {
        color: #e9d5ff;
      }
    '';
  };

  # 創建音樂腳本
  home.file.".config/waybar/scripts/music.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # 檢查是否有音樂在播放
      if ! playerctl status &> /dev/null; then
        echo '{"text": "♪ No Music", "class": "stopped", "tooltip": "No player found"}'
        exit 0
      fi

      STATUS=$(playerctl status 2>/dev/null)
      
      if [ "$STATUS" = "Playing" ]; then
        ICON="󰎈"
        CLASS="playing"
      elif [ "$STATUS" = "Paused" ]; then
        ICON="󰏤"
        CLASS="paused"
      else
        ICON="󰐎"
        CLASS="stopped"
      fi

      # 取得歌曲資訊
      ARTIST=$(playerctl metadata artist 2>/dev/null | sed 's/&/and/g')
      TITLE=$(playerctl metadata title 2>/dev/null | sed 's/&/and/g')
      
      if [ -z "$TITLE" ]; then
        echo '{"text": "♪ No Music", "class": "stopped", "tooltip": "Nothing playing"}'
        exit 0
      fi

      # 限制長度
      if [ ''${#TITLE} -gt 30 ]; then
        TITLE="''${TITLE:0:27}..."
      fi
      
      if [ ''${#ARTIST} -gt 20 ]; then
        ARTIST="''${ARTIST:0:17}..."
      fi

      # 可愛的格式
      if [ -n "$ARTIST" ]; then
        TEXT="$ICON $TITLE ♡ $ARTIST"
        TOOLTIP="Now Playing:\n$TITLE\nby $ARTIST"
      else
        TEXT="$ICON $TITLE"
        TOOLTIP="Now Playing:\n$TITLE"
      fi

      echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
    '';
  };

  # 必要套件
  home.packages = with pkgs; [
    playerctl  # 音樂控制
  ];
}
