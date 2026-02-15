# /etc/nixos/configuration.nix 或你的系統配置文件
{ config, pkgs, lib, ... }:

{
  # ====== 遊戲優化核心設置 ======
  
  # 啟用 32 位支持（Steam 和很多遊戲需要）
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # 顯卡驅動（根據你的顯卡選擇）
  # NVIDIA 用戶：
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   open = false;  # 使用閉源驅動
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  
  # AMD 用戶：
  # services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Intel 用戶：
  # services.xserver.videoDrivers = [ "modesetting" ];

  # ====== 遊戲模式 (GameMode) ======
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;  # 降低其他進程優先級
      };
      
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # ====== Steam 和遊戲平台 ======
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    
    # 額外的 Steam 庫支持
    gamescopeSession.enable = true;
  };

  # ====== 核心參數優化 ======
  boot.kernel.sysctl = {
    # 減少交換使用
    "vm.swappiness" = 10;
    
    # 文件系統優化
    "vm.vfs_cache_pressure" = 50;
    
    # 網絡優化（線上遊戲）
    "net.core.netdev_max_backlog" = 16384;
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # ====== 實時調度權限 ======
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@users";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@users";
      item = "nice";
      type = "-";
      value = "-11";
    }
  ];

  # ====== 音頻低延遲設置 ======
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # 低延遲音頻配置
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 512;
        };
      };
    };
  };

  # ====== 系統級遊戲工具 ======
  environment.systemPackages = with pkgs; [
    # 性能監控
   
    
    # Wine 和兼容層
    wine
    winetricks
    
    # 額外工具
    lutris
     heroic  
  ];

  # ====== KDE Plasma 優化 ======
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    
    # X11 性能優化
    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
  };

  # 或者如果你用 Plasma 6：
  # services.desktopManager.plasma6.enable = true;

  # ====== 文件系統優化 ======
  fileSystems."/" = {
    options = [ "noatime" "nodiratime" ];
  };

  # ====== 電源管理（筆電用戶可選） ======
  # powerManagement.cpuFreqGovernor = "performance";

  # ====== Gamepad 支援 ======
  hardware.xone.enable = true;  # Xbox 手把
  hardware.xpadneo.enable = true;  # Xbox 藍牙手把
  
  # 或者使用通用方案
  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  # ====== 防止系統休眠影響遊戲 ======
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xorg.xset}/bin/xset -dpms
  '';
}
