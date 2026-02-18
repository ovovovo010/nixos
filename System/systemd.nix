{ config, pkgs, lib, ... }:

{
  # ── Systemd 核心設定 ────────────────────────────────────────────────
  systemd.extraConfig = ''
    # 服務啟動超時（預設 90s 太長）
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=10s
    DefaultDeviceTimeoutSec=15s

    # OOM 處理（讓 systemd 而不是 kernel 處理）
    DefaultOOMPolicy=continue

    # 限制 coredump 大小
    DefaultLimitCORE=0

    # CPU/Memory accounting
    DefaultCPUAccounting=no
    DefaultMemoryAccounting=yes
    DefaultTasksAccounting=yes
    DefaultTasksMax=80%
  '';

  # ── Journal 日誌設定 ────────────────────────────────────────────────
  services.journald.extraConfig = ''
    # 限制 journal 大小，避免吃掉太多磁碟
    SystemMaxUse=512M
    SystemKeepFree=1G
    SystemMaxFileSize=128M

    # 記憶體 journal 限制
    RuntimeMaxUse=64M

    # 保留時間
    MaxRetentionSec=2week

    # 壓縮
    Compress=yes
  '';

  # ── Zram（記憶體壓縮 swap，比磁碟 swap 快很多）──────────────────────
  zramSwap = {
    enable = true;
    algorithm = "zstd";     # zstd 是壓縮率跟速度最平衡的
    memoryPercent = 50;     # 使用 50% RAM 做 zram
    priority = 100;         # 優先使用 zram 而不是磁碟 swap
  };

  # ── 開機速度優化 ────────────────────────────────────────────────────
  # systemd-boot 選單等待時間縮短
  boot.loader.timeout = lib.mkDefault 3;

  # 讓 systemd 在 initrd 階段處理（更快更現代）
  boot.initrd.systemd.enable = true;

  # ── 關機速度優化 ────────────────────────────────────────────────────
  # 讓 systemd 在 initrd 關機時快點
  systemd.services."systemd-halt".serviceConfig.TimeoutStopSec = "5s";
  systemd.services."systemd-poweroff".serviceConfig.TimeoutStopSec = "5s";
  systemd.services."systemd-reboot".serviceConfig.TimeoutStopSec = "5s";

  # ── OOM Killer 優化 ─────────────────────────────────────────────────
  # 啟用 systemd-oomd（比 kernel OOM killer 更聰明）
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  # ── 排程優化 ────────────────────────────────────────────────────────

  # ── Tmpfs 優化 ──────────────────────────────────────────────────────
  # /tmp 放在記憶體，加速暫存 IO
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "20%";    # 限制 /tmp 最多用 20% RAM
    cleanOnBoot = true;
  };

  # ── Kernel 參數優化 ─────────────────────────────────────────────────
  boot.kernel.sysctl = {
    # 記憶體管理
    "vm.swappiness" = 10;              # 盡量少用 swap
    "vm.dirty_ratio" = 10;             # dirty page 上限
    "vm.dirty_background_ratio" = 5;   # 背景寫回觸發點
    "vm.vfs_cache_pressure" = 50;      # 多保留 inode/dentry cache

    # 網路優化
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.ipv4.tcp_fastopen" = 3;       # TCP Fast Open
    "net.ipv4.tcp_mtu_probing" = 1;

    # 檔案系統
    "fs.inotify.max_user_watches" = 524288;   # 給 VSCode/Cursor 用
    "fs.inotify.max_user_instances" = 512;
  };
}
