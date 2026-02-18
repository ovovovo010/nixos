# System/btrfs.nix
{ pkgs, config, lib, ... }:
{
  # ══════════════════════════════════════════════════════════════════
  # Btrfs 文件系統管理：快照、清理、監控、維護
  # ══════════════════════════════════════════════════════════════════

  # ── 安裝 Btrfs 管理工具 ───────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    btrfs-progs       # btrfs 核心工具
    compsize          # 查看壓縮率
    snapper           # 快照管理工具
    btrbk             # 備份/快照自動化
    btrfs-assistant   # GUI 管理工具（可選）
  ];

  # ── Btrfs 自動平衡（Balance）──────────────────────────────────────
  # 定期重新平衡數據，優化空間使用
  systemd.timers.btrfs-balance = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";  # 每月執行一次
      Persistent = true;
    };
  };

  systemd.services.btrfs-balance = {
    description = "Btrfs 文件系統平衡";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;  # 低優先級，避免影響系統效能
      IOSchedulingClass = "idle";
      ExecStart = pkgs.writeShellScript "btrfs-balance" ''
        set -e
        MOUNT_POINT="/"
        
        echo "[$(date)] 開始 Btrfs 平衡..."
        
        # 只平衡使用率超過 50% 的 chunk
        ${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=50 -musage=50 "$MOUNT_POINT" || {
          echo "平衡失敗或已取消"
          exit 0
        }
        
        echo "[$(date)] Btrfs 平衡完成"
      '';
    };
  };

  # ── Btrfs Scrub（資料完整性檢查）──────────────────────────────────
  # 每月檢查並修復損壞的數據
  systemd.timers.btrfs-scrub = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
  };

  systemd.services.btrfs-scrub = {
    description = "Btrfs 資料完整性檢查";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs scrub start -B -d /";
      # -B: 阻塞模式（等待完成）
      # -d: 顯示詳細資訊
    };
    # 超時 24 小時（大容量硬碟需要）
    serviceConfig.TimeoutStartSec = "24h";
  };

  # ── Snapper 自動快照配置 ──────────────────────────────────────────
  services.snapper = {
    # Snapper 預設不啟用，因為會大量使用空間
    # 如果你想啟用自動快照，取消下面註解
    
     snapshotRootOnBoot = true;  # 開機時自動快照 /
    
    configs = {
      # 根目錄快照設定
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "eric" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        
        # 快照保留策略
        TIMELINE_MIN_AGE = "1800";      # 30 分鐘內的快照不刪除
        TIMELINE_LIMIT_HOURLY = "5";    # 保留 5 個每小時快照
        TIMELINE_LIMIT_DAILY = "7";     # 保留 7 個每日快照
        TIMELINE_LIMIT_WEEKLY = "4";    # 保留 4 個每週快照
        TIMELINE_LIMIT_MONTHLY = "3";   # 保留 3 個每月快照
        TIMELINE_LIMIT_YEARLY = "0";    # 不保留年度快照
      };
      
      # Home 目錄快照設定（可選）
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "eric" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = "1800";
        TIMELINE_LIMIT_HOURLY = "3";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "2";
        TIMELINE_LIMIT_MONTHLY = "2";
        TIMELINE_LIMIT_YEARLY = "0";
      };
    };
  };

  # ── 自動快照清理 ──────────────────────────────────────────────────
  # Snapper 會自動清理，但也可以手動設定額外的清理任務
  systemd.timers.btrfs-snapshot-cleanup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.btrfs-snapshot-cleanup = {
    description = "清理過期的 Btrfs 快照";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "cleanup-snapshots" ''
        # 使用 snapper 清理
        ${pkgs.snapper}/bin/snapper -c root cleanup timeline
        ${pkgs.snapper}/bin/snapper -c home cleanup timeline
        
        echo "快照清理完成"
      '';
    };
  };

  # ── Btrfs 壓縮設定 ────────────────────────────────────────────────
  # 如果你想在 fstab 啟用壓縮，取消下面註解並重建
  # 注意：這會影響現有掛載，建議先測試
  
  # fileSystems."/" = {
  #   options = [ "compress=zstd:3" "noatime" "space_cache=v2" ];
  # };
  # 
  # fileSystems."/home" = {
  #   options = [ "compress=zstd:3" "noatime" "space_cache=v2" ];
  # };
  # 
  # fileSystems."/nix" = {
  #   options = [ "compress=zstd:1" "noatime" "space_cache=v2" ];  # nix 已壓縮，用低等級
  # };

  # ── Btrfs 配額管理（Quota）────────────────────────────────────────
  # 啟用配額可以追蹤每個 subvolume 的空間使用
  # 注意：配額會略微影響效能
  
  # systemd.services.btrfs-enable-quota = {
  #   description = "啟用 Btrfs 配額";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "local-fs.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart = "${pkgs.btrfs-progs}/bin/btrfs quota enable /";
  #   };
  # };

  # ── 磁碟空間監控與警告 ────────────────────────────────────────────
  systemd.timers.btrfs-space-check = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.btrfs-space-check = {
    description = "檢查 Btrfs 磁碟空間使用";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "check-btrfs-space" ''
        THRESHOLD=90  # 使用率警告閾值
        
        USAGE=$(${pkgs.coreutils}/bin/df -h / | ${pkgs.gawk}/bin/awk 'NR==2 {print $5}' | ${pkgs.gnused}/bin/sed 's/%//')
        
        if [ "$USAGE" -ge "$THRESHOLD" ]; then
          echo "警告：根分區使用率達到 ''${USAGE}%"
          # 可以在這裡加入通知機制，例如：
          # ${pkgs.libnotify}/bin/notify-send "磁碟空間警告" "根分區使用率: ''${USAGE}%"
        else
          echo "磁碟空間正常：''${USAGE}%"
        fi
        
        # 顯示詳細的 Btrfs 空間資訊
        echo "=== Btrfs 空間詳情 ==="
        ${pkgs.btrfs-progs}/bin/btrfs filesystem usage /
      '';
    };
  };

  # ── 開機時檢查 Btrfs 狀態 ─────────────────────────────────────────
  systemd.services.btrfs-check-health = {
    description = "檢查 Btrfs 文件系統健康狀態";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "check-btrfs-health" ''
        echo "=== Btrfs 裝置狀態 ==="
        ${pkgs.btrfs-progs}/bin/btrfs device stats /
        
        echo ""
        echo "=== Btrfs 文件系統資訊 ==="
        ${pkgs.btrfs-progs}/bin/btrfs filesystem show /
      '';
    };
  };

  # ── 手動管理別名（加到 home.nix）──────────────────────────────────
  # programs.bash.shellAliases = {
  #   # 查看壓縮率
  #   "btrfs-compression" = "sudo compsize /";
  #   
  #   # 查看空間使用
  #   "btrfs-usage" = "sudo btrfs filesystem usage /";
  #   
  #   # 查看設備狀態
  #   "btrfs-stats" = "sudo btrfs device stats /";
  #   
  #   # 手動快照
  #   "snap-create" = "sudo snapper -c root create --description";
  #   
  #   # 列出快照
  #   "snap-list" = "sudo snapper -c root list";
  #   
  #   # 比較快照
  #   "snap-diff" = "sudo snapper -c root status";
  #   
  #   # 恢復檔案
  #   "snap-restore" = "sudo snapper -c root undochange";
  # };
}

# ═══════════════════════════════════════════════════════════════════
# 使用說明
# ═══════════════════════════════════════════════════════════════════
#
# 1. 將這個檔案放到 /etc/nixos/System/btrfs.nix
#
# 2. 在 configuration.nix 引入：
#    imports = [ ./System/btrfs.nix ];
#
# 3. 重建系統：
#    sudo nixos-rebuild switch
#
# ── Snapper 快照管理 ───────────────────────────────────────────────
#
# 【建立快照】
# sudo snapper -c root create --description "升級前備份"
# sudo snapper -c home create --description "重要文件備份"
#
# 【列出快照】
# sudo snapper -c root list
#
# 【比較快照差異】
# sudo snapper -c root status 1..2     # 比較快照 1 和 2
# sudo snapper -c root diff 1..2 /etc  # 查看 /etc 的差異
#
# 【恢復單一檔案】
# sudo snapper -c root undochange 1..2 /path/to/file
#
# 【刪除快照】
# sudo snapper -c root delete 5
# sudo snapper -c root delete 1-10     # 刪除 1 到 10 號快照
#
# 【瀏覽快照內容】
# cd /.snapshots/1/snapshot            # 快照 1 的內容
#
# ── Btrfs 維護命令 ─────────────────────────────────────────────────
#
# 【查看文件系統資訊】
# sudo btrfs filesystem show
# sudo btrfs filesystem usage /
# sudo btrfs filesystem df /
#
# 【查看壓縮率】
# sudo compsize /
# sudo compsize /home
#
# 【手動平衡】
# sudo btrfs balance start /                    # 完整平衡（慢）
# sudo btrfs balance start -dusage=50 /         # 只平衡 50% 使用的區塊
# sudo btrfs balance status /                   # 查看平衡進度
#
# 【手動 Scrub】
# sudo btrfs scrub start /
# sudo btrfs scrub status /
#
# 【查看設備狀態】
# sudo btrfs device stats /
#
# 【碎片整理】
# sudo btrfs filesystem defragment -r -v /home  # 遞迴碎片整理
#
# 【手動建立 subvolume】
# sudo btrfs subvolume create /mnt/data/@backup
# sudo btrfs subvolume list /
#
# 【快照操作】
# sudo btrfs subvolume snapshot / /.snapshots/manual-backup
# sudo btrfs subvolume delete /.snapshots/old-backup
#
# ── 緊急救援 ───────────────────────────────────────────────────────
#
# 【從快照恢復系統】
# 1. 開機進入 Live USB
# 2. 掛載 Btrfs 根分區
#    mount /dev/nvme0n1p2 /mnt
# 3. 重命名當前 root subvolume
#    mv /mnt/@root /mnt/@root.broken
# 4. 從快照建立新的 root
#    btrfs subvolume snapshot /mnt/.snapshots/X/snapshot /mnt/@root
# 5. 重新開機
#
# 【手動回滾單一檔案】
# sudo cp /.snapshots/5/snapshot/etc/nixos/configuration.nix /etc/nixos/
#
# ── 效能優化建議 ───────────────────────────────────────────────────
#
# 1. 啟用壓縮（已在配置中提供，取消註解即可）
#    - zstd:1 適合 /nix（速度優先）
#    - zstd:3 適合 / 和 /home（平衡）
#    - zstd:9 適合歸檔資料（壓縮優先）
#
# 2. 使用 noatime（已在配置中）
#    減少寫入，延長 SSD 壽命
#
# 3. space_cache=v2（已在配置中）
#    加快掛載速度
#
# 4. 定期 balance（已設定每月自動執行）
#    避免空間碎片化
#
# 5. 定期 scrub（已設定每月自動執行）
#    確保資料完整性
#
# ── 監控定時任務 ───────────────────────────────────────────────────
#
# systemctl list-timers                # 查看所有定時任務
# systemctl status btrfs-balance.timer
# systemctl status btrfs-scrub.timer
# journalctl -u btrfs-balance          # 查看執行日誌
#
# ═══════════════════════════════════════════════════════════════════
