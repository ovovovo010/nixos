# System/generation.nix
{ pkgs, config, lib, ... }:
{
  # ══════════════════════════════════════════════════════════════════
  # NixOS Generation 清理與日誌管理
  # ══════════════════════════════════════════════════════════════════

  # ── Nix Store 自動優化與垃圾回收 ────────────────────────────────
  nix.settings = {
    # 自動優化 store（移除重複檔案，建立硬連結）
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";  # 每週執行一次
    options = "--delete-older-than 30d";  # 刪除 30 天以上的 generation
    # 其他選項：
    # "--delete-older-than 7d"   - 保留 7 天
    # "--delete-older-than 60d"  - 保留 60 天
    # "--delete-generations +5"  - 只保留最新 5 個 generation
  };

  # ── Boot Loader Generation 清理 ───────────────────────────────────
  # 限制開機選單裡的 generation 數量
  boot.loader.systemd-boot.configurationLimit = 10;  # 只保留最新 10 個
  # 如果用 GRUB：
  # boot.loader.grub.configurationLimit = 10;

  # ── Systemd Journal 日誌管理 ──────────────────────────────────────
  services.journald.extraConfig = ''
    # 日誌最大容量
    SystemMaxUse=500M        # 系統日誌最多佔 500MB
    RuntimeMaxUse=100M       # 記憶體日誌最多佔 100MB
    
    # 保留時間
    MaxRetentionSec=2week    # 只保留 2 週內的日誌
    
    # 單個日誌檔案大小
    SystemMaxFileSize=50M
    RuntimeMaxFileSize=10M
    
    # 日誌壓縮
    Compress=yes
    
    # 日誌轉送到 /var/log（傳統日誌）
    ForwardToSyslog=no
    ForwardToWall=no
  '';

  # ── 傳統日誌輪替（logrotate）────────────────────────────────────
  services.logrotate = {
    enable = true;
    
    settings = {
      # 全域設定
      header = {
        dateext = true;        # 使用日期作為副檔名
        compress = true;       # 壓縮舊日誌
        delaycompress = true;  # 延遲一輪再壓縮
        notifempty = true;     # 空檔案不輪替
        missingok = true;      # 檔案不存在不報錯
      };

      # 系統日誌
      "/var/log/messages" = {
        frequency = "weekly";
        rotate = 4;            # 保留 4 份
        postrotate = "systemctl reload rsyslog 2>/dev/null || true";
      };

      # Xorg 日誌
      "/var/log/Xorg.*.log" = {
        frequency = "weekly";
        rotate = 3;
        missingok = true;
        notifempty = true;
        compress = true;
      };

      # 自訂應用日誌（範例）
      "/var/log/myapp/*.log" = {
        frequency = "daily";
        rotate = 7;
        maxsize = "100M";
        compress = true;
        delaycompress = true;
      };
    };
  };

  # ── 定期清理 /tmp 和快取 ──────────────────────────────────────────
  # /tmp 在每次重開機時自動清空（tmpfs）
  boot.tmp.cleanOnBoot = true;

  # 定期清理使用者快取
  systemd.timers.clean-user-cache = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services.clean-user-cache = {
    description = "清理使用者快取檔案";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "clean-cache" ''
        # 清理超過 30 天的快取
        ${pkgs.findutils}/bin/find /home -type d -name ".cache" -exec \
          ${pkgs.findutils}/bin/find {} -type f -mtime +30 -delete \;
        
        # 清理縮圖快取（超過 60 天）
        ${pkgs.findutils}/bin/find /home -type d -name "thumbnails" -exec \
          ${pkgs.findutils}/bin/find {} -type f -mtime +60 -delete \;
        
        echo "使用者快取清理完成"
      '';
    };
  };

  # ── 定期清理 Docker/Podman（如果有用）────────────────────────────
  systemd.timers.clean-containers = lib.mkIf config.virtualisation.docker.enable {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services.clean-containers = lib.mkIf config.virtualisation.docker.enable {
    description = "清理未使用的容器映像與快取";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker system prune -af --volumes";
    };
  };

  # ── 安裝管理工具 ──────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    ncdu          # 磁碟空間分析（互動式）
    duf           # 現代化 df
    dust          # 磁碟使用分析（樹狀圖）
    bleachbit     # GUI 清理工具
  ];

  # ── 手動清理別名（可選，加到 home.nix）──────────────────────────
  # programs.bash.shellAliases = {
  #   # 手動垃圾回收
  #   "nix-clean" = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
  #   
  #   # 列出所有 generation
  #   "nix-gens" = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
  #   
  #   # 刪除特定 generation（例如 123）
  #   "nix-del" = "sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system";
  #   
  #   # 查看日誌大小
  #   "log-size" = "journalctl --disk-usage";
  #   
  #   # 手動清理日誌（保留最近 3 天）
  #   "log-clean" = "sudo journalctl --vacuum-time=3d";
  # };
}

# ═══════════════════════════════════════════════════════════════════
# 使用說明
# ═══════════════════════════════════════════════════════════════════
#
# 1. 將這個檔案放到 /etc/nixos/System/generation.nix
#
# 2. 在 configuration.nix 引入：
#    imports = [ ./System/generation.nix ];
#
# 3. 重建系統：
#    sudo nixos-rebuild switch
#
# ── 手動管理命令 ───────────────────────────────────────────────────
#
# 【查看 Generation】
# sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
#
# 【手動垃圾回收】
# sudo nix-collect-garbage -d          # 刪除所有舊 generation
# sudo nix-collect-garbage --delete-older-than 30d  # 只刪除 30 天以上
#
# 【優化 Store】
# sudo nix-store --optimise             # 建立硬連結，節省空間
#
# 【刪除特定 Generation】
# sudo nix-env --delete-generations 123 124 --profile /nix/var/nix/profiles/system
# sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
#
# 【查看日誌使用量】
# journalctl --disk-usage
#
# 【清理日誌】
# sudo journalctl --vacuum-time=7d      # 只保留 7 天
# sudo journalctl --vacuum-size=500M    # 限制 500MB
#
# 【查看磁碟使用】
# ncdu /                                # 互動式分析
# duf                                   # 查看掛載點
# dust /nix/store                       # 查看 store 大小
#
# 【檢查定時任務狀態】
# systemctl list-timers                 # 查看所有定時任務
# systemctl status nix-gc.timer         # 查看垃圾回收狀態
# systemctl status clean-user-cache.timer
#
# ── 調整參數建議 ───────────────────────────────────────────────────
#
# 【保守策略】（適合磁碟空間充足）
# - Generation: 保留 60 天或 20 個
# - Journal: 保留 4 週，1GB
# - 快取: 保留 60 天
#
# 【積極策略】（適合磁碟空間緊張）
# - Generation: 保留 7 天或 5 個
# - Journal: 保留 1 週，200MB
# - 快取: 保留 14 天
# - 每日執行垃圾回收
#
# 【推薦策略】（平衡）
# - Generation: 30 天 + 10 個開機選項（已設定）
# - Journal: 2 週，500MB（已設定）
# - 快取: 30-60 天（已設定）
# - 每週垃圾回收（已設定）
#
# ═══════════════════════════════════════════════════════════════════
