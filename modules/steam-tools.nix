{ pkgs, ... }:

{
  # 安裝工具至使用者環境
  home.packages = with pkgs; [
    mangohud    # 效能監控覆蓋層
    gamemode    # 遊戲模式
    steam-run   # 執行非 Nix 封裝的二進位檔
    protonup-qt # 方便下載管理 Proton-GE (推薦)
  ];

  # 透過 Home Manager 直接配置 MangoHud
  programs.mangohud = {
    enable = true;
    enableSessionWide = true; # 預設開啟
    settings = {
      full = false;
      cpu_temp = true;
      gpu_temp = true;
      fps = true;
      frame_timing = 0;
      horizontal = true;
    };
  };


}
