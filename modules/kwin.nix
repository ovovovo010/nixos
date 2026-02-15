{ config, pkgs, lib, ... }:

{
  # KWin 腳本配置 - 遊戲啟動器
  home.file.".local/share/kwin/scripts/game-launcher" = {
    source = pkgs.writeTextDir "game-launcher" ''
      [Desktop Entry]
      Name=Game Launcher
      Comment=Quick game launcher with custom UI
      Icon=applications-games
      
      X-Plasma-API=javascript
      X-Plasma-MainScript=code/main.js
      X-KDE-PluginInfo-Author=User
      X-KDE-PluginInfo-Email=user@example.com
      X-KDE-PluginInfo-Name=game-launcher
      X-KDE-PluginInfo-Version=1.0
      X-KDE-PluginInfo-Website=
      X-KDE-PluginInfo-Category=Window Management
      X-KDE-PluginInfo-License=MIT
      X-KDE-PluginInfo-EnabledByDefault=true
      X-KDE-ServiceTypes=KWin/Script
    '';
    recursive = true;
  };

  home.file.".local/share/kwin/scripts/game-launcher/contents/code/main.js".text = ''
    // KWin 遊戲啟動器腳本
    
    const games = [
      {
        name: "Steam",
        exec: "steam",
        icon: "steam",
        category: "Launcher"
      },
      {
        name: "Lutris",
        exec: "lutris",
        icon: "lutris",
        category: "Launcher"
      },
      {
        name: "Heroic Games Launcher",
        exec: "heroic",
        icon: "heroic",
        category: "Launcher"
      },
      {
        name: "Minecraft",
        exec: "minecraft-launcher",
        icon: "minecraft",
        category: "Game"
      },
      // 在這裡添加更多遊戲
    ];
    
    // 註冊快捷鍵 Meta+G
    registerShortcut(
      "GameLauncher",
      "Game Launcher: Show",
      "Meta+G",
      function() {
        showGameLauncher();
      }
    );
    
    function showGameLauncher() {
      // 使用 KWin 的通知系統顯示遊戲列表
      // 注意: KWin 腳本功能有限，這裡使用 rofi 作為實際的 UI
      callDBus(
        "org.freedesktop.Notifications",
        "/org/freedesktop/Notifications",
        "org.freedesktop.Notifications",
        "Notify",
        "Game Launcher",
        0,
        "applications-games",
        "Game Launcher",
        "Press Meta+G to open game launcher",
        [],
        {},
        5000
      );
      
      // 啟動外部遊戲選單
      workspace.supportInformation();
    }
    
    print("Game Launcher KWin script loaded");
  '';

  # 使用 Rofi 作為遊戲啟動器 UI
  home.file.".config/rofi/games.rasi".text = ''
    * {
      bg: #1a1625;
      bg-alt: #2d1b4e;
      fg: #e9d5ff;
      accent: #7c3aed;
      accent-alt: #b794f6;
      
      background-color: transparent;
      text-color: @fg;
      font: "JetBrains Mono 13";
    }
    
    window {
      transparency: "real";
      background-color: @bg;
      border: 3px solid;
      border-color: @accent-alt;
      border-radius: 16px;
      width: 600px;
      location: center;
      anchor: center;
    }
    
    mainbox {
      background-color: transparent;
      children: [ inputbar, listview ];
      spacing: 15px;
      padding: 25px;
    }
    
    inputbar {
      background-color: @bg-alt;
      border-radius: 12px;
      padding: 16px 20px;
      children: [ prompt, entry ];
      spacing: 12px;
      border: 2px solid;
      border-color: @accent;
    }
    
    prompt {
      background-color: transparent;
      text-color: @accent-alt;
      font: "JetBrains Mono Bold 14";
    }
    
    entry {
      background-color: transparent;
      text-color: @fg;
      placeholder: "Search games...";
      placeholder-color: #a78bfa;
    }
    
    listview {
      background-color: transparent;
      lines: 8;
      spacing: 8px;
      scrollbar: false;
      cycle: true;
    }
    
    element {
      background-color: transparent;
      border-radius: 10px;
      padding: 12px 16px;
      orientation: horizontal;
    }
    
    element-icon {
      size: 40px;
      margin: 0px 15px 0px 0px;
    }
    
    element-text {
      background-color: transparent;
      text-color: inherit;
      vertical-align: 0.5;
    }
    
    element selected {
      background-color: @accent;
      text-color: @fg;
      border: 0px 0px 0px 4px solid;
      border-color: @accent-alt;
    }
    
    element alternate {
      background-color: transparent;
    }
  '';

  # 遊戲啟動腳本
  home.file.".local/bin/game-launcher" = {
    text = ''
      #!/usr/bin/env bash
      
      # 遊戲列表配置
      declare -A games
      games=(
        ["🎮 Steam"]="steam"
        ["🎯 Lutris"]="lutris"
        ["🦸 Heroic Games"]="heroic"
        ["⛏️  Minecraft"]="minecraft-launcher"
        ["🎲 Prism Launcher"]="prismlauncher"
        ["🎪 Bottles"]="bottles"
        ["🎸 Osu!"]="osu-stable"
        ["🏎️  MangoHud"]="mangohud"
      )
      
      # 生成選單
      game_list=""
      for name in "''${!games[@]}"; do
        game_list+="$name\n"
      done
      
      # 使用 rofi 顯示選單
      selected=$(echo -e "$game_list" | rofi \
        -dmenu \
        -i \
        -p "🎮 Games" \
        -theme ~/.config/rofi/games.rasi \
        -no-custom \
        -format s)
      
      # 啟動選中的遊戲
      if [ -n "$selected" ]; then
        command="''${games[$selected]}"
        if [ -n "$command" ]; then
          notify-send "🎮 Launching" "$selected" -t 2000 -i applications-games
          nohup $command &>/dev/null &
        fi
      fi
    '';
    executable = true;
  };

  # KDE 快捷鍵配置
  home.file.".config/kglobalshortcutsrc".text = lib.mkAfter ''
    [game-launcher.desktop]
    _k_friendly_name=Game Launcher
    launch=Meta+G,none,Launch Game Launcher
  '';

  # 創建 .desktop 檔案用於快捷鍵綁定
  xdg.desktopEntries.game-launcher = {
    name = "Game Launcher";
    genericName = "Quick Game Launcher";
    comment = "Launch games quickly with Meta+G";
    icon = "applications-games";
    exec = "${config.home.homeDirectory}/.local/bin/game-launcher";
    terminal = false;
    categories = [ "Game" "Utility" ];
    type = "Application";
  };

  # 依賴套件
  home.packages = with pkgs; [
    libnotify  # 用於通知
    rofi       # 用於 UI
  ];

  # KDE Plasma 配置
  programs.plasma = lib.mkIf (config.programs.plasma.enable or false) {
    shortcuts = {
      "game-launcher.desktop" = {
        "launch" = "Meta+G";
      };
    };
  };
}
