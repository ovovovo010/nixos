{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # 終端模擬器
    kitty
    
    # 瀏覽器
    firefox
    
    # 編輯器
    neovim
    
    # Wayland 工具
    waybar
    rofi
    hyprshot          # 截圖工具
    grim              # Wayland 截圖
    slurp             # 區域選擇
    swappy            # 截圖編輯
    
    # 版本控制
    git
    
    # 媒體
    mpv               # 影片播放器
    wl-clipboard      # Wayland 剪貼簿
    
    # 系統工具
    btop              # 系統監控
    fastfetch         # 系統資訊顯示
    
    # 檔案搜尋工具
    ripgrep           # 快速搜尋
    fd                # 快速查找文件
    fzf               # 模糊查找
    
    # 增強命令列工具
    eza               # 更好的 ls
    bat               # 更好的 cat
    
    # Git TUI
    lazygit           # Git 圖形界面
    
     wget            # 下載工具
     curl            # HTTP 客戶端
     jq              # JSON 處理
     yq              # YAML 處理
     unzip           # 解壓縮
     zip             # 壓縮
     jdk21
     prismlauncher
     zip
     protonvpn-gui
     protonup-qt
     vim
     pciutils
     hydroxide
     cava
     swww
     pywal
     hypridle
     hyprlock
     swaynotificationcenter
     yazi
     heroic
     qpwgraph
     easyeffects
     docker
     vesktop
     wf-recorder
     r2modman
     code-cursor
  ];
}
