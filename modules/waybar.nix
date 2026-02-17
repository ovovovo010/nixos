{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [{
      layer = "top";
      position = "top";
      height = 36;
      margin-top = 8;
      margin-left = 12;
      margin-right = 12;
      spacing = 0;
      exclusive = true;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "pulseaudio"
        "network"
        "battery"
        "cpu"
        "memory"
        "tray"
      ];

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
          active = "";
          urgent = "";
          default = "";
        };
        persistent-workspaces = {
          "*" = 5;
        };
        on-click = "activate";
        sort-by-number = true;
      };

      "hyprland/window" = {
        format = "  {}";
        max-length = 40;
        separate-outputs = true;
      };

      "clock" = {
        format = "  {:%H:%M}";
        format-alt = "  {:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months   = "<span color='#cad3f5'><b>{}</b></span>";
            days     = "<span color='#cad3f5'>{}</span>";
            weeks    = "<span color='#91d7e3'><b>W{}</b></span>";
            weekdays = "<span color='#c6a0f6'><b>{}</b></span>";
            today    = "<span color='#ed8796'><b><u>{}</u></b></span>";
          };
        };
      };

      "pulseaudio" = {
        format        = "{icon}  {volume}%";
        format-muted  = "󰖁  muted";
        format-icons  = {
          default  = [ "󰕿" "󰖀" "󰕾" ];
          headphone = "󰋋";
          headset   = "󰋎";
        };
        on-click  = "pavucontrol";
        scroll-step = 5;
      };

      "network" = {
        format-wifi        = "󰤨  {essid}";
        format-ethernet    = "󰈀  {ipaddr}";
        format-disconnected = "󰤭  offline";
        format-alt         = "  {ipaddr}/{cidr}";
        tooltip-format     = "{ifname}: {ipaddr}\n{gwaddr} via {essid}";
        on-click-right     = "nm-connection-editor";
      };

      "battery" = {
        states = {
          good     = 80;
          warning  = 30;
          critical = 15;
        };
        format          = "{icon}  {capacity}%";
        format-charging = "󰂄  {capacity}%";
        format-plugged  = "󰚥  {capacity}%";
        format-icons    = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      "cpu" = {
        format   = "  {usage}%";
        tooltip  = true;
        interval = 2;
      };

      "memory" = {
        format         = "  {used:0.1f}G";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
        interval       = 5;
      };

      "tray" = {
        icon-size = 14;
        spacing   = 8;
      };
    }];

    style = ''
      /* ── Catppuccin Macchiato palette ─────────────────────────── */
      @define-color base     #1e2030;
      @define-color mantle   #181926;
      @define-color crust    #131421;
      @define-color surface0 #363a4f;
      @define-color surface1 #494d64;
      @define-color surface2 #5b5f77;
      @define-color overlay0 #6e738d;
      @define-color overlay1 #8087a2;
      @define-color overlay2 #939ab7;
      @define-color text     #cad3f5;
      @define-color subtext  #a5adcb;
      @define-color mauve    #c6a0f6;
      @define-color red      #ed8796;
      @define-color peach    #f5a97f;
      @define-color yellow   #eed49f;
      @define-color green    #a6da95;
      @define-color teal     #8bd5ca;
      @define-color sky      #91d7e3;
      @define-color sapphire #7dc4e4;
      @define-color blue     #8aadf4;
      @define-color lavender #b7bdf8;
      @define-color pink     #f5bde6;

      /* ── Reset ────────────────────────────────────────────────── */
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK TC", monospace;
        font-size: 13px;
        font-weight: 500;
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        padding: 0;

      }

      /* ── 整條 bar 容器 ────────────────────────────────────────── */
      window#waybar {
        background: transparent;
      }

      window#waybar > box {
        /* 深色半透明底 */
        background: alpha(@base, 0.93);

        /* 邊框：上亮下暗，製造凸起立體感 */
        border-top:    1px solid alpha(@surface2, 0.65);
        border-left:   1px solid alpha(@surface1, 0.5);
        border-right:  1px solid alpha(@surface0, 0.4);
        border-bottom: 1px solid alpha(@crust,    0.9);
        border-radius: 10px;

        /* 多層陰影 = 懸浮立體感 */
        box-shadow:
          /* 頂部內高光 */
          0  1px 0 alpha(@overlay0, 0.12) inset,
          /* 底部內陰影 */
          0 -1px 0 alpha(@crust,    0.45) inset,
          /* 主投影 */
          0  4px 14px alpha(@crust, 0.65),
          0  8px 28px alpha(@crust, 0.30),
          /* 近距離輪廓陰影 */
          0  1px  4px alpha(@crust, 0.85);

        padding: 0 6px;
      }

      /* ── 所有 module 基礎樣式 ─────────────────────────────────── */
      #workspaces,
      #window,
      #clock,
      #pulseaudio,
      #network,
      #battery,
      #cpu,
      #memory,
      #tray {
        color: @subtext;
        padding: 0 10px;
        background: transparent;
        transition: color 0.15s ease;
      }

      /* ── 右側 module 之間加分隔線 ─────────────────────────────── */
      #pulseaudio {
        border-left: 1px solid alpha(@surface0, 0.45);
        margin-left: 2px;
        padding-left: 12px;
      }

      #tray {
        border-left: 1px solid alpha(@surface0, 0.45);
        margin-left: 2px;
        padding-left: 12px;
        padding-right: 4px;
      }

      /* ── Workspaces ───────────────────────────────────────────── */
      #workspaces {
        padding: 0 2px;
      }

      #workspaces button {
        color: @overlay1;
        background: transparent;
        padding: 0 7px;
        margin: 5px 2px;
        border-radius: 5px;
        border: 1px solid transparent;
        font-size: 12px;
        min-width: 0;
        transition: all 0.15s ease;
      }

      #workspaces button:hover {
        color: @text;
        background: alpha(@surface0, 0.55);
        border-color: alpha(@surface1, 0.5);
        box-shadow:
          0 1px 0 alpha(@overlay0, 0.1) inset,
          0 2px 6px alpha(@crust, 0.5);
      }

      #workspaces button.active {
        color: @mauve;
        background: alpha(@surface0, 0.75);
        border-color: alpha(@mauve, 0.30);
        font-weight: 700;
        box-shadow:
          0 0  8px alpha(@mauve, 0.18),
          0 1px 0  alpha(@lavender, 0.18) inset,
          0 2px 6px alpha(@crust, 0.55);
      }

      #workspaces button.urgent {
        color: @red;
        border-color: alpha(@red, 0.4);
        animation: blink 1s ease infinite;
      }

      @keyframes blink {
        0%   { color: @red; }
        50%  { color: alpha(@red, 0.4); }
        100% { color: @red; }
      }

      /* ── Window title ─────────────────────────────────────────── */
      #window {
        color: @overlay2;
        font-size: 12px;
        font-style: italic;
        border-left: 1px solid alpha(@surface0, 0.45);
        margin-left: 2px;
        padding-left: 12px;
      }

      /* ── Clock ────────────────────────────────────────────────── */
      #clock {
        color: @lavender;
        font-weight: 700;
        font-size: 14px;
        letter-spacing: 0.5px;
      }

      /* ── Right modules 顏色 ───────────────────────────────────── */
      #pulseaudio           { color: @teal;     }
      #pulseaudio.muted     { color: @overlay0; }
      #network              { color: @sapphire; }
      #network.disconnected { color: @red;      }
      #battery              { color: @green;    }
      #battery.warning      { color: @yellow;   }
      #battery.critical     { color: @red;      }
      #battery.charging     { color: @green;    }
      #cpu                  { color: @peach;    }
      #memory               { color: @pink;     }
      #tray                 { color: @overlay1; }

      /* hover 時統一提亮 */
      #pulseaudio:hover,
      #network:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover {
        color: @text;
      }

      #tray > .passive         { -gtk-icon-effect: dim; }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: alpha(@red, 0.18);
        border-radius: 4px;
      }
    '';
  };
}
