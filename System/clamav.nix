# System/clamav.nix 或 configuration.nix
{ pkgs, ... }:
{
  # ── ClamAV 防毒服務 ──────────────────────────────────────────────
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;  # 自動更新病毒資料庫
    
    # 更新頻率（預設每天一次）
    updater.frequency = 24;  # 小時
    
    # 掃描設定
    daemon.settings = {
      # 日誌位置
      LogFile = "/var/log/clamav/clamd.log";
      LogTime = true;
      LogFileMaxSize = "10M";
      
      # 掃描設定
      MaxDirectoryRecursion = 20;
      FollowDirectorySymlinks = false;
      FollowFileSymlinks = false;
      
      # 效能調校
      MaxThreads = 12;
      OnAccessMaxFileSize = "100M";
      
      # 偵測選項
      DetectPUA = true;  # 偵測潛在不需要的應用程式
      ScanArchive = true;
      ScanELF = true;
      ScanPDF = true;
      
      # Socket 設定（讓 clamdscan 可以連接）
      LocalSocket = "/run/clamav/clamd.ctl";
      LocalSocketMode = "666";
    };
  };

  # ── 安裝 ClamAV 命令列工具 ────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    clamav  # 包含 clamscan, clamdscan, freshclam 等工具
  ];

  # ── 自動化定期掃描（可選） ────────────────────────────────────────
  # 每週日凌晨 3 點掃描 /home 目錄
  systemd.timers.clamav-scan = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 03:00:00";  # 每週日 3 AM
      Persistent = true;  # 錯過時間會補跑
    };
  };

  systemd.services.clamav-scan = {
    description = "ClamAV 定期掃描";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.clamav}/bin/clamdscan --multiscan --fdpass /home 2>&1 | tee -a /var/log/clamav/scan.log'";
      # 如果想掃描整個系統，改成：
      # ExecStart = "... clamdscan --multiscan --fdpass / --exclude-dir=^/sys --exclude-dir=^/proc --exclude-dir=^/dev ...";
    };
  };

  # ── 日誌輪替設定 ──────────────────────────────────────────────────
  services.logrotate.settings.clamav = {
    files = "/var/log/clamav/*.log";
    frequency = "weekly";
    rotate = 4;
    compress = true;
    delaycompress = true;
    missingok = true;
    notifempty = true;
  };
}

# ═══════════════════════════════════════════════════════════════════
# 使用說明
# ═══════════════════════════════════════════════════════════════════
#
# 1. 將這個檔案放到 /etc/nixos/System/clamav.nix
#
# 2. 在 configuration.nix 引入：
#    imports = [ ./System/clamav.nix ];
#
# 3. 重建系統：
#    sudo nixos-rebuild switch
#
# 4. 手動掃描命令：
#    # 快速掃描（直接用 clamscan，不需 daemon）
#    clamscan -r /home/eric
#    
#    # 使用 daemon 掃描（更快，因為 daemon 已載入病毒庫）
#    clamdscan --multiscan --fdpass /home/eric
#    
#    # 掃描單一檔案
#    clamscan suspicious_file.exe
#    
#    # 掃描並移除感染檔案
#    clamdscan --multiscan --remove /path/to/scan
#
# 5. 更新病毒資料庫（通常自動執行，也可手動）：
#    sudo systemctl start clamav-freshclam
#
# 6. 查看掃描日誌：
#    journalctl -u clamav-scan
#    cat /var/log/clamav/scan.log
#
# 7. 調整自動掃描時間：
#    修改 OnCalendar 參數
#    - 每天 2 AM: "daily 02:00"
#    - 每週一 3 AM: "Mon *-*-* 03:00:00"
#    - 每月 1 號: "*-*-01 03:00:00"
#
# ═══════════════════════════════════════════════════════════════════
