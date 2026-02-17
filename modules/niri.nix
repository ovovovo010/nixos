{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl" = {
    force = true;
    text = ''
    input {
      keyboard {
        xkb {
          layout "us"
        }
        repeat-delay 600
        repeat-rate 25
      }
      pointer {
        accel-speed 0.2
        accel-profile "flat"
      }
      touchpad {
        tap
        natural-scroll
        click-method "clickfinger"
      }
    }

    layout {
      gaps 16
      default-column-width { fixed 600; }
      center-focused-column "always"
    }

    animations {
      slowdown 1.0
    }

    binds {
      // 終端機
      Mod+Return { spawn "kitty"; }

      // 應用程式選單
      Mod+D { spawn "rofi" "-show" "drun"; }

      // 檔案管理器
      Mod+E { spawn "thunar"; }

      // 關閉視窗
      Mod+Q { close-window; }

      // 全螢幕
      Mod+F { fullscreen-window; }

      // 浮動切換
      Mod+V { toggle-window-floating; }

      // 退出
      Mod+Shift+Q { quit; }

      // 焦點切換
      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+K { focus-window-up; }
      Mod+J { focus-window-down; }

      // 移動視窗
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+K { move-window-up; }
      Mod+Shift+J { move-window-down; }

      // 工作區
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }

      Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+Shift+4 { move-window-to-workspace 4; }
      Mod+Shift+5 { move-window-to-workspace 5; }

      // 媒體鍵
      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }
    }

    environment {
      XCURSOR_SIZE "24"
    }
  '';
  };

  home.packages = with pkgs; [
    kitty
    rofi
    brightnessctl
    wl-clipboard
    playerctl
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
  };
}
