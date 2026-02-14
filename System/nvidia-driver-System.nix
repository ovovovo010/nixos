{ config, pkgs, ... }:

{
  # 核心參數：必須開啟 nvidia-drm.modeset 與 fbdev 
  # 這能修正 Wayland 下的啟動閃爍問題並支援 Gamescope
  boot.kernelParams = [ 
    "nvidia-drm.modeset=1" 
    "nvidia_drm.fbdev=1" 
  ];

  # 啟用 NVIDIA 驅動
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # 必須開啟，Wayland (Hyprland/Niri/Gamescope) 核心需求
    modesetting.enable = true;
    
    # 針對 RTX 4060 建議使用閉源驅動以獲得完整效能與 DLSS 支援
    open = false;
    
    # 使用穩定版驅動
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # 針對 Wayland 的電力管理優化，開啟此項能顯著改善掛起喚醒後的畫面錯誤
    powerManagement.enable = true; 
    powerManagement.finegrained = false;

    nvidiaSettings = true;
  };

  # 顯卡硬體支援與 32-bit 相容性（Steam 必備）
# 顯卡硬體支援與 32-bit 相容性（Steam 必備）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver  # 修正：原 vaapiVdpau 已更名
      libvdpau-va-gl
    ];
  };
  # 系統級環境變數優化
  environment.sessionVariables = {
    # 視訊加速與後端設定
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    # 修正 Gamescope/Wayland 下 NVIDIA 可能發生的彩屏或閃爍
    WLR_NO_HARDWARE_CURSORS = "1"; 
    
    # 改善 Firefox/Chrome 等應用的硬體加速
    NVD_BACKEND = "direct";
    
    # 解決某些舊遊戲在 Wayland 下的色彩空間問題
    # 如果進入 Gamescope 仍有彩屏，請將此行加入 Steam 啟動選項而非此處
    # gamescope --force-windows-icons --prefer-output 8
  };

  # 針對 NVIDIA 優化的 Gamescope 補強
  programs.gamescope = {
    enable = true;
    capSysNice = true; # 提升遊戲進程優先權
  };
}
