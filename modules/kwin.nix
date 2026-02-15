{ config, pkgs, ... }:

{
    home-manager.users.eric = {
    # 宣告 HM 版本 (必要)
    home.stateVersion = "25.11";

    home-manager.users.eric.home.packages = with pkgs; [
    
    
    
    # Wine (如果需要跑 Windows 遊戲)
    wineWowPackages.stable
    winetricks
    
    # Vulkan 支援
    vulkan-tools
    vulkan-loader
  ];
    programs.mangohud = {
      enable = true;
      settings = {
        cpu_stats = true;
        gpu_stats = true;
        fps = true;
        frametime = true;
        ram = true;
        vram = true;
        table_columns = 3;
        font_size = 24;
        background_alpha = "0.5";
        round_corners = 10;
        position = "top-left";
        toggle_hud = "Shift_R+F12";
        toggle_logging = "Shift_L+F2";
      };
    };
  };


 
  
    
}
