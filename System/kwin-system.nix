# System/kwin-system.nix
{ config, pkgs, lib, ... }:

{
  # ====== 遊戲優化核心設置 ======
  
  # 啟用 32 位支持（新語法）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # 顯卡驅動（根據你的顯卡取消註解）
  # NVIDIA:
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  
  # AMD:
  # services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Intel:
  # services.xserver.videoDrivers = [ "modesetting" ];

  # ====== 遊戲模式 ======
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
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

  # ====== Steam ======
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # ====== 核心參數優化 ======
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
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

  # ====== 音頻低延遲 ======
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
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
    gamemode
    wine
    winetricks
    lutris
  ];

  # ====== KDE Plasma 6 ======
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  services.xserver = {
    enable = true;
    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
  };

  # ====== 文件系統優化 ======
  fileSystems."/" = {
    options = [ "noatime" "nodiratime" ];
  };

  # ====== Gamepad 支援 ======
  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;

  # ====== 防止休眠 ======
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xorg.xset}/bin/xset -dpms
  '';
}
