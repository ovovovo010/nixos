{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 0;
        exclusive = true;
        passthrough = false;
        fixed-center = true;

        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "custom/music"
          "cpu"
          "memory"
          "pulseaudio"
          "network"
          "tray"
        ];

        # Logo
        "custom/logo" = {
          format = "  ";
          tooltip = false;
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
            urgent = "";
            default = "○";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # 當前窗口標題
        "hyprland/window" = {
          format = "  {}";
          max-length = 40;
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "  $1";
            "(.*) - fish" = "  $1";
            "(.*) - nvim" = "  $1";
          };
        };

        # 時鐘（中央）
        "clock" = {
          format = "  {:%H:%M}";
          format-alt = "  {:%a %b %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              months = "<span color='#7aa2f7'><b>{}</b></span>";
              days = "<span color='#a9b1d6'>{}</span>";
              weekdays = "<span color='#7dcfff'><b>{}</b></span>";
              today = "<span color='#f7768e'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        # 🎵 音樂播放器
        "custom/music" = {
          format = "{}";
          max-length = 40;
          interval = 2;
          exec = "~/.config/waybar/scripts/music.sh";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
          return-type = "json";
          escape = true;
        };

        # CPU
        "cpu" = {
          format = "  {usage}%";
          tooltip-format = "CPU: {usage}%\nLoad: {load}";
          interval = 2;
        };

        # 記憶體
        "memory" = {
          format = "  {percentage}%";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
          interval = 2;
        };

        # 音量
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "  muted";
          format-icons = {
            headphone = "";
            headset = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        # 網路
        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "  offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{gwaddr}";
          on-click = "nm-connection-editor";
        };

        # 系統托盤
        "tray" = {
          icon-size = 16;
          spacing = 6;
        };
      };
    };

    style = ''
      /* ── Tokyo Night 漂浮圓角風 ── */
      @define-color bg        #1a1b2e;
      @define-color bg1       #16213e;
      @define-color surface   #24283b;
      @define-color overlay   #292e42;
      @define-color blue      #7aa2f7;
      @define-color cyan      #7dcfff;
      @define-color purple    #bb9af7;
      @define-color red       #f7768e;
      @define-color yellow    #e0af68;
      @define-color green     #9ece6a;
      @define-color fg        #c0caf5;
      @define-color fg-dim    #565f89;
      @define-color border    #3d59a1;

      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK TC", monospace;
        font-size: 13px;
        font-weight: 500;
        border: none;
        border-radius: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      /* ── Bar 主體：透明背景，讓模組漂浮 ── */
      window#waybar {
        background-color: transparent;
        color: @fg;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        margin: 6px 8px;
      }

      /* ── 左側：Logo ── */
      #custom-logo {
        background-color: @blue;
        color: @bg;
        padding: 0 14px;
        font-size: 16px;
        border-radius: 10px 0 0 10px;
        margin-right: 0;
      }

      /* ── 工作區 ── */
      #workspaces {
        background-color: @surface;
        border-radius: 0 10px 10px 0;
        padding: 0 6px;
        margin-right: 6px;
      }

      #workspaces button {
        background-color: transparent;
        color: @fg-dim;
        padding: 0 10px;
        min-width: 28px;
        border-bottom: 2px solid transparent;
        transition: all 0.15s ease;
      }

      #workspaces button:hover {
        background-color: @overlay;
        color: @fg;
        border-radius: 8px;
      }

      #workspaces button.active {
        background-color: @blue;
        color: @bg;
        border-radius: 8px;
      }

      #workspaces button.urgent {
        background-color: @red;
        color: @bg;
        border-radius: 8px;
      }

      /* ── 窗口標題 ── */
      #window {
        background-color: @surface;
        color: @fg-dim;
        padding: 0 14px;
        border-radius: 10px;
        font-weight: 500;
        font-size: 12px;
        margin-left: 0;
      }

      /* ── 中央時鐘 ── */
      #clock {
        background-color: @surface;
        color: @blue;
        font-size: 14px;
        font-weight: 700;
        padding: 0 22px;
        border-radius: 10px;
        letter-spacing: 1px;
        border: 1px solid @border;
        min-width: 120px;
      }

      /* ── 右側模組通用 ── */
      #custom-music,
      #cpu,
      #memory,
      #pulseaudio,
      #network {
        background-color: @surface;
        color: @fg;
        padding: 0 14px;
        margin-left: 4px;
        border-radius: 10px;
      }

      /* ── 音樂 ── */
      #custom-music {
        color: @purple;
        background-color: @bg1;
        border: 1px solid @border;
      }

      #custom-music.paused {
        color: @fg-dim;
      }

      #custom-music.stopped {
        color: @fg-dim;
        font-style: italic;
      }

      /* ── CPU ── */
      #cpu {
        color: @cyan;
      }

      #cpu.warning {
        color: @yellow;
      }

      #cpu.critical {
        color: @red;
        animation: blink 1s step-end infinite;
      }

      /* ── 記憶體 ── */
      #memory {
        color: @green;
      }

      #memory.warning {
        color: @yellow;
      }

      #memory.critical {
        color: @red;
      }

      /* ── 音量 ── */
      #pulseaudio {
        color: @blue;
      }

      #pulseaudio.muted {
        color: @fg-dim;
      }

      /* ── 網路 ── */
      #network {
        color: @cyan;
      }

      #network.disconnected {
        color: @red;
      }

      /* ── 托盤 ── */
      #tray {
        background-color: @surface;
        border-radius: 10px;
        padding: 0 10px;
        margin-left: 4px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: @red;
      }

      /* ── Tooltip ── */
      tooltip {
        background-color: @bg;
        border: 1px solid @border;
        border-radius: 10px;
        color: @fg;
        padding: 6px 10px;
      }

      tooltip label {
        color: @fg;
        font-weight: 500;
      }

      /* ── Blink animation ── */
      @keyframes blink {
        50% { opacity: 0.4; }
      }
    '';
  };

  # 音樂腳本
  home.file.".config/waybar/scripts/music.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if ! playerctl status &>/dev/null; then
        echo '{"text":"  no music","class":"stopped","tooltip":"No player"}'
        exit 0
      fi

      STATUS=$(playerctl status 2>/dev/null)
      case "$STATUS" in
        Playing) ICON="󰎈"; CLASS="playing" ;;
        Paused)  ICON="󰏤"; CLASS="paused"  ;;
        *)       ICON="󰐎"; CLASS="stopped" ;;
      esac

      TITLE=$(playerctl metadata title  2>/dev/null | sed 's/&/and/g')
      ARTIST=$(playerctl metadata artist 2>/dev/null | sed 's/&/and/g')

      [ -z "$TITLE" ] && {
        echo '{"text":"  no music","class":"stopped","tooltip":"Nothing playing"}'
        exit 0
      }

      [ ''${#TITLE}  -gt 25 ] && TITLE="''${TITLE:0:22}..."
      [ ''${#ARTIST} -gt 15 ] && ARTIST="''${ARTIST:0:12}..."

      if [ -n "$ARTIST" ]; then
        TEXT="$ICON  $TITLE — $ARTIST"
        TOOLTIP="$TITLE\n$ARTIST"
      else
        TEXT="$ICON  $TITLE"
        TOOLTIP="$TITLE"
      fi

      echo "{\"text\":\"$TEXT\",\"class\":\"$CLASS\",\"tooltip\":\"$TOOLTIP\"}"
    '';
  };

  home.packages = with pkgs; [
    playerctl
  ];
}
