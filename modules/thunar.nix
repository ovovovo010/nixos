{ config, pkgs, ... }:

{
  # 直接安裝 Thunar 及其插件（Home Manager 方式）
  home.packages = with pkgs; [
    # Thunar 核心和插件
    xfce.thunar
    xfce.thunar-archive-plugin    # 壓縮檔管理
    xfce.thunar-volman           # 可移動設備管理
    xfce.thunar-media-tags-plugin # 媒體標籤編輯
    
    
    ffmpegthumbnailer    # 影片縮圖
    
    # 壓縮工具（配合 archive-plugin 使用）
    xarchiver            # GUI 壓縮工具
    
    # 掛載工具
    gvfs                 # 虛擬檔案系統
    udisks2              # 磁碟管理
    
    # 圖片和影片查看器
    imv                  # Wayland 圖片查看器
    zathura              # PDF 閱讀器
    
  ];

  # 檔案關聯和 MIME 類型處理
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # 文字檔案
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      
      # 圖片
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      
      # PDF
      "application/pdf" = "org.pwmt.zathura.desktop";
      
      # 影片
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      
      # 音訊
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      
      # 壓縮檔
      "application/zip" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
      "application/x-7z-compressed" = "xarchiver.desktop";
      
      # 資料夾（預設用 Thunar 開啟）
      "inode/directory" = "thunar.desktop";
    };
  };

  # XDG 用戶目錄（桌面、下載等）
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = "$HOME/Templates";
    publicShare = "$HOME/Public";
  };

  # Thunar 自定義動作配置
  xdg.configFile = {
    # 自定義右鍵選單動作
    "Thunar/uca.xml" = {
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
          <!-- 在終端開啟 -->
          <action>
            <icon>utilities-terminal</icon>
            <name>在終端開啟</name>
            <unique-id>1234567890123-1</unique-id>
            <command>kitty --working-directory %f</command>
            <description>在此資料夾開啟終端</description>
            <patterns>*</patterns>
            <directories/>
          </action>

          <!-- 用 Neovim 編輯 -->
          <action>
            <icon>nvim</icon>
            <name>用 Neovim 編輯</name>
            <unique-id>1234567890123-2</unique-id>
            <command>kitty nvim %f</command>
            <description>用 Neovim 開啟檔案</description>
            <patterns>*</patterns>
            <text-files/>
          </action>

          <!-- 複製路徑 -->
          <action>
            <icon>edit-copy</icon>
            <name>複製路徑</name>
            <unique-id>1234567890123-3</unique-id>
            <command>echo -n %f | wl-copy</command>
            <description>複製完整路徑到剪貼簿</description>
            <patterns>*</patterns>
            <other-files/>
            <directories/>
          </action>

          <!-- 用 VSCode 開啟 -->
          <action>
            <icon>code</icon>
            <name>用 VSCode 開啟</name>
            <unique-id>1234567890123-4</unique-id>
            <command>code %f</command>
            <description>用 VSCode 開啟</description>
            <patterns>*</patterns>
            <directories/>
            <text-files/>
          </action>

          <!-- 搜尋檔案內容 -->
          <action>
            <icon>system-search</icon>
            <name>搜尋內容</name>
            <unique-id>1234567890123-5</unique-id>
            <command>kitty --hold sh -c 'rg -i "%s" %f'</command>
            <description>在檔案中搜尋文字</description>
            <patterns>*</patterns>
            <directories/>
          </action>

          <!-- 計算資料夾大小 -->
          <action>
            <icon>folder</icon>
            <name>計算大小</name>
            <unique-id>1234567890123-6</unique-id>
            <command>kitty --hold sh -c 'du -sh %f'</command>
            <description>顯示資料夾大小</description>
            <patterns>*</patterns>
            <directories/>
          </action>
        </actions>
      '';
      # 如果文件已存在則強制覆蓋
      force = true;
    };
  };

 }
