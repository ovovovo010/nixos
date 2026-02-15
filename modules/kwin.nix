{ config, pkgs, ... }:

{
  # 啟用 KDE Plasma
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # 或者如果你用 Plasma 6，註解掉上面的 plasma5，改用下面這行
  # services.desktopManager.plasma6.enable = true;

  # 基本的遊戲支援
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # 遊戲相關套件
  environment.systemPackages = with pkgs; [
    # 基本的遊戲支援
    gamemode
    mangohud
    
    # Wine (如果需要跑 Windows 遊戲)
    wine
    winetricks
    
    # Vulkan 支援
    vulkan-tools
    vulkan-loader
  ];

  # 啟用 GameMode (自動優化遊戲效能)
  programs.gamemode.enable = true;

  # 圖形驅動 (根據你的顯卡選擇其中一個，其他註解掉)
  
  # NVIDIA 顯卡:
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   open = false;  # 開源驅動改 true
  # };
  
  # AMD 顯卡:
  # services.xserver.videoDrivers = [ "amdgpu" ];
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };
  
  # Intel 顯卡:
  # services.xserver.videoDrivers = [ "intel" ];
}
