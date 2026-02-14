{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 8;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ 
          "pulseaudio" 
          "network" 
          "cpu" 
          "memory" 
          "temperature"
          "battery" 
          "tray" 
        ];

        # 工作區配置
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
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
            default = "●";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # 窗口標題
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        # 時鐘
        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%Y年%m月%d日 %A}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#c4a7e7'><b>{}</b></span>";
              days = "<span color='#e0def4'>{}</span>";
              weeks = "<span color='#9ccfd8'><b>W{}</b></span>";
              weekdays = "<span color='#f6c177'><b>{}</b></span>";
              today = "<span color='#eb6f92'><b><u>{}</u></b></span>";
            };
          };
        };

        # CPU
        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip = true;
        };

        # 記憶體
        memory = {
          interval = 2;
          format = " {percentage}%";
          tooltip-format = "使用: {used:0.1f}GB / {total:0.1f}GB";
        };

        # 溫度
        temperature = {
          interval = 2;
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
        };

        # 網路
        network = {
          interval = 2;
          format-wifi = " {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ 離線";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n {bandwidthDownBits}  {bandwidthUpBits}";
        };

        # 音量
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " 靜音";
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

        # 電池
        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        # 系統托盤
        tray = {
          spacing = 10;
        };
      };
    };

    # 樣式配置
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK TC", sans-serif;
        font-size: 14px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: rgba(25, 23, 36, 0.85);
        color: #e0def4;
        border-bottom: 3px solid #c4a7e7;
      }

      /* 工作區 */
      #workspaces {
        background: transparent;
        margin: 4px 8px;
      }

      #workspaces button {
        padding: 0 12px;
        background: rgba(49, 50, 68, 0.6);
        color: #908caa;
        border-radius: 8px;
        margin: 0 3px;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background: rgba(110, 106, 134, 0.4);
        color: #c4a7e7;
        box-shadow: 0 0 10px rgba(196, 167, 231, 0.3);
      }

      #workspaces button.active {
        background: linear-gradient(135deg, #c4a7e7 0%, #9ccfd8 100%);
        color: #191724;
        box-shadow: 0 0 15px rgba(196, 167, 231, 0.5);
      }

      #workspaces button.urgent {
        background: #eb6f92;
        color: #191724;
        animation: blink 1s ease-in-out infinite;
      }

      /* 窗口標題 */
      #window {
        margin: 4px 8px;
        padding: 0 12px;
        color: #c4a7e7;
        font-weight: 500;
      }

      /* 時鐘 */
      #clock {
        background: linear-gradient(135deg, #c4a7e7 0%, #9ccfd8 50%, #f6c177 100%);
        color: #191724;
        padding: 0 20px;
        margin: 4px 0;
        border-radius: 8px;
        font-weight: bold;
        box-shadow: 0 0 15px rgba(196, 167, 231, 0.4);
      }

      /* 右側模塊通用樣式 */
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #tray {
        padding: 0 12px;
        margin: 4px 3px;
        background: rgba(49, 50, 68, 0.6);
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      #pulseaudio:hover,
      #network:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover,
      #battery:hover {
        background: rgba(110, 106, 134, 0.5);
        box-shadow: 0 0 10px rgba(196, 167, 231, 0.3);
      }

      /* 音量 */
      #pulseaudio {
        color: #c4a7e7;
      }

      #pulseaudio.muted {
        color: #6e6a86;
      }

      /* 網路 */
      #network {
        color: #9ccfd8;
      }

      #network.disconnected {
        color: #eb6f92;
      }

      /* CPU */
      #cpu {
        color: #f6c177;
      }

      /* 記憶體 */
      #memory {
        color: #ebbcba;
      }

      /* 溫度 */
      #temperature {
        color: #31748f;
      }

      #temperature.critical {
        color: #eb6f92;
        animation: blink 1s ease-in-out infinite;
      }

      /* 電池 */
      #battery {
        color: #9ccfd8;
      }

      #battery.charging {
        color: #a6da95;
      }

      #battery.warning:not(.charging) {
        color: #f6c177;
      }

      #battery.critical:not(.charging) {
        color: #eb6f92;
        animation: blink 1s ease-in-out infinite;
      }

      /* 托盤 */
      #tray {
        background: rgba(49, 50, 68, 0.4);
      }

      #tray > .passive {
        opacity: 0.6;
      }

      #tray > .needs-attention {
        color: #eb6f92;
        animation: blink 1s ease-in-out infinite;
      }

      /* 動畫 - 修正後的語法 */
      @keyframes blink {
        0% {
          opacity: 1;
        }
        50% {
          opacity: 0.5;
        }
        100% {
          opacity: 1;
        }
      }

      /* Tooltip */
      tooltip {
        background: rgba(25, 23, 36, 0.95);
        border: 2px solid #c4a7e7;
        border-radius: 8px;
        padding: 8px;
      }

      tooltip label {
        color: #e0def4;
      }
    '';
  };
}
