# modules/openbox.nix
{ pkgs, ... }:
{
  # ── 安裝所需套件 ────────────────────────────────────────────────
  home.packages = with pkgs; [
    openbox          # 視窗管理器
    picom            # 透明/陰影合成器
    tint2            # 工具列
    obconf           # Openbox GUI 設定工具（可選）
    lxappearance     # GTK 主題切換（可選）
    feh              # 設定桌布（輕量）
  ];

  # ── Openbox autostart ────────────────────────────────────────────
  # 登入 Openbox 時自動執行的程式
  xdg.configFile."openbox/autostart" = {
    text = ''
      # 設定桌布（把路徑換成你自己的圖片）
      feh --bg-fill ~/Pictures/wallpaper.jpg &

      # 啟動合成器
      picom --config ~/.config/picom/picom.conf &

      # 啟動工具列
      tint2 &
    '';
    executable = true;
  };

  # ── Openbox rc.xml（基本按鍵綁定） ───────────────────────────────
  xdg.configFile."openbox/rc.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_config xmlns="http://openbox.org/3.4/rc"
                    xmlns:xi="http://www.w3.org/2001/XInclude">

      <resistance><strength>10</strength><screen_edge_strength>20</screen_edge_strength></resistance>
      <focus><focusNew>yes</focusNew><followMouse>no</followMouse><focusLast>yes</focusLast><underMouse>no</underMouse><focusDelay>200</focusDelay><raiseOnFocus>no</raiseOnFocus></focus>
      <placement><policy>Smart</policy><center>yes</center><monitor>Primary</monitor></placement>

      <theme>
        <name>Clearlooks</name>
        <titleLayout>NLC</titleLayout>
        <keepBorder>yes</keepBorder>
        <animateIconify>yes</animateIconify>
        <font place="ActiveWindow"><name>Sans</name><size>10</size><weight>Bold</weight><slant>Normal</slant></font>
        <font place="InactiveWindow"><name>Sans</name><size>10</size><weight>Normal</weight><slant>Normal</slant></font>
        <font place="MenuItem"><name>Sans</name><size>10</size><weight>Normal</weight><slant>Normal</slant></font>
        <font place="OSD"><name>Sans</name><size>12</size><weight>Bold</weight><slant>Normal</slant></font>
      </theme>

      <desktops>
        <number>4</number>
        <firstdesk>1</firstdesk>
        <names><name>1</name><name>2</name><name>3</name><name>4</name></names>
        <popupTime>875</popupTime>
      </desktops>

      <resize><drawContents>yes</drawContents><popupShow>Nonpixel</popupShow><popupPosition>Center</popupPosition></resize>
      <margins><top>0</top><bottom>0</bottom><left>0</left><right>0</right></margins>
      <dock><position>TopLeft</position><floating>no</floating><noStrut>no</noStrut><stacking>Above</stacking><direction>Vertical</direction><autoHide>no</autoHide><hideDelay>300</hideDelay><showDelay>300</showDelay><moveButton>Middle</moveButton></dock>

      <keyboard>
        <!-- 應用程式快捷鍵 -->
        <keybind key="W-Return">  <!-- Super+Enter 開終端 -->
          <action name="Execute"><command>xterm</command></action>
        </keybind>
        <keybind key="W-d">       <!-- Super+D 開選單 -->
          <action name="Execute"><command>dmenu_run</command></action>
        </keybind>
        <keybind key="W-q">       <!-- Super+Q 關閉視窗 -->
          <action name="Close"/>
        </keybind>
        <keybind key="W-f">       <!-- Super+F 全螢幕 -->
          <action name="ToggleFullscreen"/>
        </keybind>

        <!-- 虛擬桌面切換 -->
        <keybind key="W-1"><action name="GoToDesktop"><to>1</to></action></keybind>
        <keybind key="W-2"><action name="GoToDesktop"><to>2</to></action></keybind>
        <keybind key="W-3"><action name="GoToDesktop"><to>3</to></action></keybind>
        <keybind key="W-4"><action name="GoToDesktop"><to>4</to></action></keybind>

        <!-- 移動視窗到虛擬桌面 -->
        <keybind key="W-S-1"><action name="SendToDesktop"><to>1</to></action></keybind>
        <keybind key="W-S-2"><action name="SendToDesktop"><to>2</to></action></keybind>
        <keybind key="W-S-3"><action name="SendToDesktop"><to>3</to></action></keybind>
        <keybind key="W-S-4"><action name="SendToDesktop"><to>4</to></action></keybind>

        <!-- 視窗焦點切換 -->
        <keybind key="A-Tab">
          <action name="NextWindow"><finalactions><action name="Focus"/><action name="Raise"/><action name="Unshade"/></finalactions></action>
        </keybind>
        <keybind key="A-S-Tab">
          <action name="PreviousWindow"><finalactions><action name="Focus"/><action name="Raise"/><action name="Unshade"/></finalactions></action>
        </keybind>
      </keyboard>

      <mouse>
        <dragThreshold>8</dragThreshold>
        <doubleClickTime>200</doubleClickTime>
        <screenEdgeWarpTime>400</screenEdgeWarpTime>
        <screenEdgeWarpMouse>false</screenEdgeWarpMouse>
        <context name="Frame">
          <mousebind button="A-Left" action="Press"><action name="Focus"/><action name="Raise"/></mousebind>
          <mousebind button="A-Left" action="Click"><action name="Focus"/></mousebind>
          <mousebind button="A-Left" action="Drag"><action name="Move"/></mousebind>
          <mousebind button="A-Right" action="Press"><action name="Focus"/><action name="Raise"/><action name="Resize"/></mousebind>
        </context>
        <context name="Desktop">
          <mousebind button="Right" action="Press">
            <action name="ShowMenu"><menu>root-menu</menu></action>
          </mousebind>
        </context>
        <context name="Titlebar">
          <mousebind button="Left" action="Press"><action name="Focus"/><action name="Raise"/></mousebind>
          <mousebind button="Left" action="Drag"><action name="Move"/></mousebind>
          <mousebind button="Left" action="DoubleClick"><action name="ToggleMaximize"/></mousebind>
        </context>
        <context name="Close">
          <mousebind button="Left" action="Press"><action name="Focus"/><action name="Raise"/><action name="Unshade"/></mousebind>
          <mousebind button="Left" action="Click"><action name="Close"/></mousebind>
        </context>
      </mouse>

      <menu>
        <file>menu.xml</file>
        <hideDelay>200</hideDelay>
        <middle>no</middle>
        <submenuShowDelay>100</submenuShowDelay>
        <submenuHideDelay>400</submenuHideDelay>
        <applicationIcons>yes</applicationIcons>
        <manageDesktops>yes</manageDesktops>
      </menu>

      <applications/>
    </openbox_config>
  '';

  # ── Openbox 右鍵選單 ─────────────────────────────────────────────
  xdg.configFile."openbox/menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu xmlns="http://openbox.org/3.4/menu">
      <menu id="root-menu" label="Openbox">
        <item label="終端機"><action name="Execute"><command>xterm</command></action></item>
        <item label="檔案管理器"><action name="Execute"><command>thunar</command></action></item>
        <separator/>
        <menu id="apps-menu" label="應用程式">
          <item label="Firefox"><action name="Execute"><command>firefox</command></action></item>
        </menu>
        <separator/>
        <item label="重新整理 Openbox"><action name="Reconfigure"/></item>
        <item label="登出"><action name="Exit"><prompt>yes</prompt></action></item>
      </menu>
    </openbox_menu>
  '';

  # ── Picom 配置 ───────────────────────────────────────────────────
  xdg.configFile."picom/picom.conf".text = ''
    # 後端（glx 效能較好，xrender 相容性較高）
    backend = "glx";
    glx-no-stencil = true;
    glx-copy-from-front = false;
    use-damage = true;

    # 透明度
    inactive-opacity = 0.92;
    active-opacity = 1.0;
    frame-opacity = 1.0;
    inactive-opacity-override = false;

    # 不透明例外（避免某些視窗被強制透明）
    opacity-rule = [
      "100:class_g = 'Firefox'",
      "100:class_g = 'mpv'"
    ];

    # 陰影
    shadow = true;
    shadow-radius = 12;
    shadow-offset-x = -7;
    shadow-offset-y = -7;
    shadow-opacity = 0.5;
    shadow-exclude = [
      "name = 'Notification'",
      "class_g = 'Conky'",
      "class_g ?= 'Notify-osd'",
      "_GTK_FRAME_EXTENTS@:c"
    ];

    # 淡入淡出
    fading = true;
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    fade-delta = 5;

    # 圓角
    corner-radius = 8;
    rounded-corners-exclude = [
      "window_type = 'dock'",
      "window_type = 'desktop'"
    ];

    # 效能
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    detect-transient = true;
    detect-client-leader = true;
  '';

  # ── Tint2 配置 ───────────────────────────────────────────────────
  xdg.configFile."tint2/tint2rc".text = ''
    # 全域設定
    scale = 1
    tint2_config_version = 2

    # 工作區列（虛擬桌面）
    taskbar_mode = multi_desktop
    taskbar_padding = 2 3 2
    taskbar_background_id = 0
    taskbar_active_background_id = 0
    taskbar_name = 1
    taskbar_name_padding = 6 4
    taskbar_name_active_background_id = 0
    taskbar_name_active_font_color = #e0e0e0 100
    taskbar_name_font_color = #888888 100

    # 工作列（Panel）
    panel_items = TSC
    panel_size = 100% 36
    panel_margin = 0 0
    panel_padding = 4 0 4
    panel_background_id = 1
    panel_position = bottom center horizontal
    panel_layer = bottom
    panel_monitor = all
    panel_shrink = 0
    autohide = 0
    autohide_show_timeout = 0.3
    autohide_hide_timeout = 1.5
    autohide_height = 2

    # 工作視窗（Task）
    task_text = 1
    task_icon = 1
    task_centered = 1
    urgent_nb_of_blink = 8
    task_maximum_size = 160 35
    task_padding = 4 4 4
    task_background_id = 2
    task_active_background_id = 3
    task_urgent_background_id = 4
    task_iconified_background_id = 2
    mouse_left = toggle_iconify
    mouse_middle = close
    mouse_right = none
    mouse_scroll_up = next_task
    mouse_scroll_down = prev_task

    # 時鐘
    time1_format = %H:%M
    time2_format = %Y-%m-%d
    time1_font = Sans Bold 11
    time2_font = Sans 9
    clock_font_color = #e0e0e0 100
    clock_padding = 6 0
    clock_background_id = 0
    clock_tooltip = %A, %B %d

    # 系統匣
    systray_padding = 4 4 4
    systray_background_id = 0
    systray_sort = ascending
    systray_icon_size = 22
    systray_icon_asb = 100 0 0

    # 背景定義
    # id=1 工作列底色（深色半透明）
    rounded = 0
    border_width = 0
    border_sides = TBLR
    background_color = #1a1a2e 88
    border_color = #1a1a2e 0
    background_color_hover = #1a1a2e 88
    border_color_hover = #1a1a2e 0
    background_color_pressed = #1a1a2e 88
    border_color_pressed = #1a1a2e 0

    # id=2 一般任務
    rounded = 4
    border_width = 1
    border_sides = TBLR
    background_color = #2a2a3e 60
    border_color = #4a4a6e 40
    background_color_hover = #3a3a4e 80
    border_color_hover = #6a6aae 60
    background_color_pressed = #3a3a4e 80
    border_color_pressed = #6a6aae 60

    # id=3 作用中任務
    rounded = 4
    border_width = 1
    border_sides = TBLR
    background_color = #7aa2f7 80
    border_color = #7aa2f7 100
    background_color_hover = #7aa2f7 90
    border_color_hover = #7aa2f7 100
    background_color_pressed = #7aa2f7 90
    border_color_pressed = #7aa2f7 100

    # id=4 緊急任務
    rounded = 4
    border_width = 1
    border_sides = TBLR
    background_color = #f7768e 80
    border_color = #f7768e 100
    background_color_hover = #f7768e 90
    border_color_hover = #f7768e 100
    background_color_pressed = #f7768e 90
    border_color_pressed = #f7768e 100
  '';
}
