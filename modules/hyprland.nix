{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    # 可選：如果你用 systemd integration（大多數人開），這確保環境變數傳遞
    # systemd.enable = true;  # 預設是 true，如果你有問題可試 false

    settings = {
      # 1. 環境變數
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRSHOT_DIR,$HOME/Pictures/Screenshots"
      ];

      # 2. 基本輸入
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      # 3. 手勢配置（最新版）
      gestures = {
        gesture = [
          "3, horizontal, workspace"
          # 如果方向不對，改用下面兩行取代上面一行
          # "3, left, workspace, r+1"
          # "3, right, workspace, r-1"
        ];
        workspace_swipe_distance = 400;
        workspace_swipe_invert = false;
        workspace_swipe_min_speed_to_force = 50;
        workspace_swipe_cancel_ratio = 0.4;
        workspace_swipe_create_new = false;
      };

      # 4. 變數定義
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";

      # 5. 按鍵綁定
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, R, exec, $menu"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, f, fullscreen,"

        # 焦點移動 (vim 風格)
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # 工作區切換
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # 移動視窗到工作區（全補齊）
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # 特殊工作區
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, exec, hyprshot -m region --output-folder ~/Pictures/screenshots"

        # 滑鼠滾輪切換 workspace
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # 音量/亮度（media keys）
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # 6. 視窗規則
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, class:^(pavucontrol)$"
        "opacity 0.9 0.9, class:^(kitty)$"
        "opacity 0.95 0.95, class:^(thunar)$"
      ];

      # 7. 一般配置 (你的紫羅蘭色系)
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(c4a7e7ee) rgba(9ccfd8ee) 45deg";
        "col.inactive_border" = "rgba(6e6a86aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
        animation = [
          "windows, 1, 5, myBezier"
          "workspaces, 1, 4, default, slide"
        ];
      };

      # 8. 自動啟動程式（最新格式，直接寫在 settings 裡）
      exec-once = [
        "dbus-update-activation-environment --systemd --all"  # 重要！確保環境變數傳給所有服務

        # 加你想開的程式（範例，依需求改/加）
         "hyprpaper"
	 "fcitx5 -d"
        # "~/.config/hypr/scripts/init.sh &"  # 自訂腳本
	"swww-daemon --format xrgb"
        "swww img /home/eric/Pictures/wallpapers/tokyo_night_city_skyscrapers_121628_3840x2160.jpg --transition-type fade --tansition-duration 2"
      ];

      # 如果需要每次 reload 都跑的（很少用）
      # exec = [ "notify-send 'Hyprland Reloaded'" ];
    };

    # 額外原始 config（你的 mouse 設定）
    extraConfig = ''
      device {
        name = epic-mouse-v1
        sensitivity = -0.5
      }
    '';
  };

  # 必要套件
  home.packages = with pkgs; [
    hyprshot grim slurp swappy
    brightnessctl playerctl wl-clipboard
    # 如果你要用 waybar、hyprpaper 等，建議也加進來
    # waybar hyprpaper swww dunst copyq networkmanagerapplet blueman
  ];
}
