{ config, pkgs, lib, ... }:

{
  # ── Systemd 核心設定 ────────────────────────────────────────────────
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "15s";
    DefaultTimeoutStopSec = "10s";
    DefaultDeviceTimeoutSec = "15s";
    DefaultOOMPolicy = "continue";
    DefaultLimitCORE = "0";
    DefaultMemoryAccounting = true;
    DefaultTasksAccounting = true;
    DefaultTasksMax = "80%";
  };

  # ── Journal 日誌設定 ────────────────────────────────────────────────
  services.journald.extraConfig = ''
    SystemMaxUse=512M
    SystemKeepFree=1G
    SystemMaxFileSize=128M
    RuntimeMaxUse=64M
    MaxRetentionSec=2week
    Compress=yes
  '';

  # ── Zram ────────────────────────────────────────────────────────────
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  # ── 開機優化 ────────────────────────────────────────────────────────
  boot.loader.timeout = lib.mkDefault 3;
  boot.initrd.systemd.enable = true;

  # ── /tmp 放記憶體 ───────────────────────────────────────────────────
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "20%";
    cleanOnBoot = true;
  };

  # ── OOM Killer ──────────────────────────────────────────────────────
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  # ── 關機加速 ────────────────────────────────────────────────────────
  systemd.services."systemd-halt".serviceConfig.TimeoutStopSec = "5s";
  systemd.services."systemd-poweroff".serviceConfig.TimeoutStopSec = "5s";
  systemd.services."systemd-reboot".serviceConfig.TimeoutStopSec = "5s";

  # ── Kernel sysctl ───────────────────────────────────────────────────
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;
  };
}
